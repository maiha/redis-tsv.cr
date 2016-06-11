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
    def import(io : IO, delimiter : String)
      raw.pipelined do |pipeline|
        io.each_line do |line|
          ary = line.split(/#{delimiter}/, 2)
          key = ary[0]
          val = ary[1]
          pipeline.set(key, val)
        end
      end
    end

    def export(io : IO, delimiter : String)
      keys = raw.keys("*").map(&.to_s)
      vals = raw.mget(keys)
      vals.each_with_index do |val, i|
        io.puts "#{keys[i]}#{delimiter}#{val}"
      end
      io.flush
    end

    def keys(progress : Bool, count : Int32)
      report = build_periodical_report(progress, 3.seconds)

      i = 0
      raw.each_keys(count: count) do |keys|
        i += keys.size
        yield keys
        report.call(i)
      end
    end

    private def build_periodical_report(progress : Bool, interval : Time::Span)
      return ->(i : Int32){} if progress == false
      total = count
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
