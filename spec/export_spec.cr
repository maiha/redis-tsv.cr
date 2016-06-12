require "./spec_helper"

describe RedisTsv do
  describe "#export" do
    it "to tsv file" do
      flushdb

      redis = RedisTsv.new
      redis.raw.set("foo", "1")
      redis.raw.set("bar", "2")
      redis.count.should eq(2)

      lines = export(delimiter: "\t")
      lines.should eq(["bar\t2", "foo\t1"])
      
      redis.close
    end

    it "to csv file" do
      flushdb

      redis = RedisTsv.new
      redis.raw.set("foo", "1")
      redis.raw.set("bar", "2")
      redis.count.should eq(2)

      lines = export(delimiter: ",")
      lines.should eq(["bar,2", "foo,1"])
      
      redis.close
    end
  end
end
