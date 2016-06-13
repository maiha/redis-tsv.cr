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

  # instance creation
  def self.new
    new(host: "localhost", port: 6379)
  end
  
  ######################################################################
  ### as class

  getter! raw
  delegate close, raw

  def initialize(host, port, password = nil)
    @raw = Redis.new(host: host, port: port, password: password)
  end
end

require "./periodical"
require "./redis-tsv/*"
