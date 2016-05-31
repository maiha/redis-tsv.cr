require "redis"

class RedisTsv
  module Info
    def info
      raw.string_command(["INFO"])
    end

    def version
      case info
      when /^redis_version:(.*?)$/m
        return $1
      else
        raise ManagedError.new("Not Found (broken INFO)")
      end
    end
    
    def count
      case info
      when /^[^:]+:keys=(\d+)/m
        return $1.to_i
      when /^redis_version/m
        return 0
      else
        raise ManagedError.new("Not Found (unexpected INFO)")
      end
    end
  end

  include Info
end
