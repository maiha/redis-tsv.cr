require "redis"

class Redis
  module Commands
    def mget(keys : Array(String))
      string_array_command(concat(["MGET"], keys))
    end
  end
end

class RedisTsv
  module Bulk
    def import(io : IO, delimiter : String, progress : Bool, count : Int32)
      report = build_periodical_report(progress, 3.seconds, ->{count_line(io)})
      
      lines = [] of String
      flush = ->(i : Int32){
        regex  = /#{delimiter}/                                             
        raw.pipelined do |pipeline|
          lines.each do |line|
            k, v = line.split(regex, 2)
            pipeline.set(k, v)
          end
        end
        lines.clear
        report.call(i)
      }
      
      cnt = 0
      io.each_line do |line|
        cnt += 1
        lines << line.chomp
        if cnt % count == 0
          flush.call(cnt)
        end
      end
      flush.call(cnt)
    end

    def export(io : IO, delimiter : String, progress : Bool, count : Int32)
      report = build_periodical_report(progress, 3.seconds, ->{self.count})

      cnt = 0
      raw.each_keys(count: count) do |keys|
        next if keys.size == 0
        vals = raw.mget(keys)
        buf = String.build {|b|
          keys.zip(vals){ |k,v| b << "#{k}#{delimiter}#{v}\n" }
        }
        io.puts buf
        cnt += keys.size
        report.call(cnt)
      end
      io.flush
    end

    def keys(progress : Bool, count : Int32)
      report = build_periodical_report(progress, 3.seconds, ->{self.count})

      i = 0
      raw.each_keys(count: count) do |keys|
        i += keys.size
        yield keys
        report.call(i)
      end
    end

    private def count_line(io : IO) : Int32
      cnt = 0
      io.each_line{|line| cnt+=1}
      io.rewind
      return cnt
    end

    private def build_periodical_report(progress : Bool, interval : Time::Span, total_func : -> Int32)
      return ->(i : Int32){} if progress == false
      total = total_func.call
      reported = Time.now
      return ->(i : Int32){
        now = Time.now
        if total > 0 && reported + interval < now
          pcent = [i * 100.0 / total, 100.0].min
          time = now.to_s("%H:%M:%S")
          STDERR.puts "%s [%-3.1f%%] (%d/%d)" % [time, pcent, i, total]
          STDERR.flush
          reported = now
        end
      }
    end      
  end

  include Bulk
end
