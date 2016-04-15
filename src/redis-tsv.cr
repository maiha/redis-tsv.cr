require "redis"
require "./redis-tsv/*"

class RedisTsv
  include Bulk

  getter! raw
  delegate close, raw

  def initialize(host, port)
    @raw = Redis.new(host, port)
  end
end
