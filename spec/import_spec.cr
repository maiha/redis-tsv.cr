require "./spec_helper"

describe RedisTsv do
  describe "#import" do
    it "from tsv file" do
      flushdb

      redis = RedisTsv.new
      redis.count.should eq(0)

      import(["foo\t1", "bar\t2"], delimiter: "\t")

      redis.count.should eq(2)

      redis.raw.get("foo").should eq("1")
      redis.raw.get("bar").should eq("2")
      
      redis.close
    end

    it "from csv file" do
      flushdb

      redis = RedisTsv.new
      redis.count.should eq(0)

      import(["foo,1", "bar,2"], ",")

      redis.count.should eq(2)

      redis.raw.get("foo").should eq("1")
      redis.raw.get("bar").should eq("2")
      
      redis.close
    end

    it "skips lines when delimiter not found" do
      flushdb

      redis = RedisTsv.new
      redis.count.should eq(0)

      import(["foo\t1", "bar2", "baz\t3"], "\t")

      redis.count.should eq(2)

      redis.raw.get("foo").should eq("1")
      redis.raw.get("baz").should eq("3")
      
      redis.close
    end
  end
end
