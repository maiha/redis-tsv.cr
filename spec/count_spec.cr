require "./spec_helper"

describe RedisTsv do
  describe "#count" do
    it "counts item number as Int32" do
      redis = RedisTsv.new
      redis.count.should be_a(Int32)
      redis.close
    end

    it "succ 1 after adding a new item" do
      redis = RedisTsv.new
      redis.raw.del "foo"
      old = redis.count

      redis.raw.set "foo", "a"
      redis.count.should eq(old + 1)
      redis.close
    end
  end
end
