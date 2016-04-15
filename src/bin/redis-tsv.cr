require "../redis-tsv"
require "../options"

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
    EOF

  def run
    op = args.shift { die "missing command: import or export", "", usage }

    case op
    when "import"
      file = args.shift { die "missing input tsv file", "", usage }
      File.open(file) {|io| redis.import(io, delimiter) }
    when "export"
      redis.export(STDOUT, delimiter)
    when "keys"
      redis.raw.keys("*").map(&.to_s).sort.each do |i|
        puts i
      end
    else
      die "unknown command: #{op}", "", usage
    end
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
