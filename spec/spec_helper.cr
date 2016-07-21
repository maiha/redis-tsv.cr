require "spec"
require "../src/redis-tsv"
require "tempfile"

def flushdb
  redis = RedisTsv.new
  redis.raw.flushdb
  redis.close
end

def import(lines : Array(String), delimiter : String, progress : Bool = false, count : Int32 = 1000)
  io = IO::Memory.new
  lines.each do |line|
    io.puts line
  end
  io.rewind
  
  redis = RedisTsv.new
  redis.import(io: io, delimiter: delimiter, progress: progress, count: count)
  redis.close
end

def export(delimiter : String, progress : Bool = false, count : Int32 = 1000)
  io = IO::Memory.new
  redis = RedisTsv.new
  redis.export(io: io, delimiter: delimiter, progress: progress, count: count)
  redis.close
  String.new(io.to_slice).chomp.split("\n").sort
end

def keys( progress : Bool = false, count : Int32 = 1000)
  lines = [] of String
  redis = RedisTsv.new
  redis.keys(progress: false, count: 1000) do |ary|
    lines += ary
  end
  redis.close
  return lines.sort
end
