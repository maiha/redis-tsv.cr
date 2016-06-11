require "../redis-tsv"
require "../options"
require "colorize"

class Main
  include Options

  option host : String, "-h HOST", "--host=HOST", "redis host", "localhost"
  option port : Int32 , "-p PORT", "--port=PORT", "redis port", 6379
  option delimiter : String, "-d STRING", "--delimiter=STRING", "default is TAB", "\t"
  option count : Int32, "-c 1000", "--count=1000", "bulk count passed to Redis SCAN command", 1000
  option quiet : Bool, "-q", "--quiet", "suppress progress reporting", false
  
  usage <<-EOF
    Usage: #{$0} (import|export|keys) [file]

    Options:

    Example: (bulk commands)
      #{$0}     import foo.tsv
      #{$0} -d, import foo.csv
      #{$0}     export > foo.tsv
      #{$0} -d, export > foo.csv
      #{$0}     keys > keys.list

    Other utility commands:
      count, info, ping, version
    EOF

  def run
    op = args.shift { die "missing command: import or export" }

    case op
    when "count"
      puts redis.count
    when "export"
      redis.export(STDOUT, delimiter, progress: !quiet, count: count)
    when "import"
      file = args.shift { die "missing input tsv file" }
      File.open(file) {|io| redis.import(io, delimiter) }
    when "info"
      puts redis.info
    when "keys"
      redis.keys(progress: !quiet, count: count) do |keys|
        STDOUT.puts keys.join("\n")
      end
    when "ping"
      puts redis.raw.ping
    when "stest"
      prefix = args.shift { die "stest expects prefix(String) for 1st arg" }
      count  = args.shift { die "stest expects count(Int32) for 2nd arg" }
      redis.stest(prefix, count.to_i)
    when "version"
      puts redis.version
    else
      die "unknown command: #{op}"
    end
  rescue err : RedisTsv::ManagedWarn
    STDERR.puts err.to_s.colorize(:yellow)
    exit 2
  rescue err : RedisTsv::ManagedError | Errno
    STDERR.puts err.to_s.colorize(:red)
    exit 1
  ensure
    redis.close
  end

  protected def redis
    case @redis
    when Nil
      @redis = RedisTsv.new(host, port)
    else
      @redis.not_nil!
    end
  end
end

Main.new.run
