require "../redis-tsv"
require "../options"
require "colorize"

class Main
  include Options

  option host : String, "-h HOST", "--host=HOST", "redis host", "localhost"
  option port : Int32 , "-p PORT", "--port=PORT", "redis port", 6379
  option delimiter : String, "-d STRING", "--delimiter=STRING", "default is TAB", "\t"
  
  usage <<-EOF
    Usage: #{$0} (import|export) [file]

    Options:

    Example:
      #{$0} import foo.tsv
      #{$0} export > foo.tsv

    Undocumented Commands:
      count, info, ping, version
    EOF

  def run
    op = args.shift { die "missing command: import or export", "", usage }

    case op
    when "count"
      puts redis.count
    when "export"
      redis.export(STDOUT, delimiter)
    when "import"
      file = args.shift { die "missing input tsv file", "", usage }
      File.open(file) {|io| redis.import(io, delimiter) }
    when "info"
      puts redis.info
    when "keys"
      redis.raw.keys("*").each do |i|
        puts i.to_s
      end
    when "ping"
      puts redis.raw.ping
    when "version"
      puts redis.version
    else
      die "unknown command: #{op}", "", usage
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
