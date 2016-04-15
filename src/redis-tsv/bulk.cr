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
      keys = raw.keys("*").map(&.to_s).sort
      vals = raw.mget(keys)
      vals.each_with_index do |val, i|
        io.puts "#{keys[i]}#{delimiter}#{val}"
      end
      io.flush
    end
  end
end
