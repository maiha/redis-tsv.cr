require "redis"

class RedisTsv
  module Stest
    def stest(prefix : String, count : Int32)
      reporter = Periodical.reporter(true, 3.seconds, ->{count})

      one_test = ->(i : Int32) {
        key = "#{prefix}#{i}"
        raw.set key, i.to_s
        raw.get key
      }

      cnt = 0
      count.times do
        cnt += 1
        one_test.call(cnt)
        reporter.report(cnt) if cnt % 1000 == 0
      end

      reporter.done
    end
  end

  include Stest
end
