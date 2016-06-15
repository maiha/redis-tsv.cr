require "./spec_helper"

describe RedisTsv do
  describe "#role" do
    it "return 'master' or 'slave'" do
      redis = RedisTsv.new
      redis.role.should eq("master") # in travis-ui
      redis.close
    end
  end
end
