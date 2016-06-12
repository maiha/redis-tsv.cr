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
      reporter = Periodical.reporter(progress, 3.seconds, ->{count_line(io)})
      
      lines = [] of String
      flush = ->(i : Int32){
        return if lines.empty?
        regex = /#{delimiter}/                                             
        raw.pipelined do |pipeline|
          lines.each do |line|
            ary = line.split(regex, 2)
            if ary.size == 2
              pipeline.set(ary[0], ary[1])
            else
              # skip
            end
          end
        end
        lines.clear
        reporter.report(i)
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
      reporter.done
    end

    def export(io : IO, delimiter : String, progress : Bool, count : Int32)
      keys(progress, count) do |keys|
        next if keys.empty?
        vals = raw.mget(keys)
        buf = String.build {|b|
          keys.zip(vals){ |k,v| b << "#{k}#{delimiter}#{v}\n" }
        }
        io.puts buf
      end
      io.flush
    end

    def keys(progress : Bool, count : Int32)
      redis = self
      reporter = Periodical.reporter(progress, 3.seconds, ->(){redis.count})

      i = 0
      raw.each_keys(count: count) do |keys|
        i += keys.size
        yield keys
        reporter.report(i)
      end
      reporter.done
    end

    private def count_line(io : IO) : Int32
      cnt = 0
      io.each_line{|line| cnt+=1}
      io.rewind
      return cnt
    end
  end

  include Bulk
end
