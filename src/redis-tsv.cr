require "redis"

class RedisTsv
  ######################################################################
  ### as module

  # Yes, we expect this will happen, the backtraces will not be printed.
  class ManagedError < Exception
  end
  
  # Yes, we expect this will happen and it's not so important.
  class ManagedWarn < Exception
  end
  
  ######################################################################
  ### as class

  getter! raw
  delegate close, raw

  def initialize(host, port)
    @raw = Redis.new(host, port)
  end
end

require "./redis-tsv/*"
