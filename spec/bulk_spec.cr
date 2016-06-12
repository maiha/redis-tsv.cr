require "./spec_helper"

describe RedisTsv do
  describe "(migration)" do
    it "works well with progress reporting" do
      flushdb

      redis = RedisTsv.new
      redis.count.should eq(0)

      # prepare data
      (1..10000).each do |i|
        redis.raw.set(i.to_s, i.to_s)
      end

      # export: backup to tsv
      tsvs = export(delimiter: "\t", progress: true)

      # delete db
      flushdb
      redis.count.should eq(0)
      
      # import: restore from tsv
      import(lines: tsvs, delimiter: "\t", progress: true)
      redis.count.should eq(10000)

      # keys
      lines = keys(progress: true)
      lines.should eq((1..10000).map(&.to_s).sort)
      
      redis.close
    end
  end
end
