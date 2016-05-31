require "./spec_helper"

# test cases are derived from stefanwille/crystal-redis to provide same api
describe RedisTsv do
  describe ".new" do
    it "connects to default host and port" do
      redis = RedisTsv.new
    end

    it "connects to specific port and host / disconnects" do
      redis = RedisTsv.new(host: "localhost", port: 6379)
    end
  end

  describe "#close" do
    it "closes the connection" do
      redis = RedisTsv.new
      redis.close
    end

    it "tolerates a duplicate call" do
      redis = RedisTsv.new
      redis.close
      redis.close
    end
  end
end
