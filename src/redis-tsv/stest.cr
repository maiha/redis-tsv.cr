require "redis"

class RedisTsv
  module Stest
    def stest(prefix : String, count : Int32)
      reporting_interval = 3.seconds
      started_at = Time.now
      last_reported_at = started_at
      last_reported_count = 0
      one_test = ->(i : Int32) {
        now = Time.now
        key = "#{prefix}#{i}"
        val = "#{i}"
        raw.set key, val
        raw.get key
        if last_reported_at + reporting_interval < now
          took = now - last_reported_at
          qps = (i - last_reported_count)*1000.0 / took.total_milliseconds
          puts "%s %d (%.1f qps)" % [now, i, qps]
          last_reported_at = now
          last_reported_count = i
        end
      }
      count.times do |i|
        one_test.call(i)
      end
      # last reporting
      now = Time.now
      total_time = now - started_at
      puts "#{now} #{count} writes/reads done (#{total_time} sec)"
      puts "%.1f qps (read + write / sec)" % [count / total_time.to_f]
    end
  end

  include Stest
end
