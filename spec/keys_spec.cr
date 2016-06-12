require "./spec_helper"

describe RedisTsv do
  describe "#keys" do
    it "scan keys" do
      flushdb

      redis = RedisTsv.new
      redis.raw.set("foo", "1")
      redis.raw.set("bar", "2")
      redis.count.should eq(2)

      lines = keys(progress: false)
      lines.should eq(["bar", "foo"])
      
      redis.close
    end
  end
end
