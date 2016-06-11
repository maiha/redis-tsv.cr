require "redis"

class Redis
  module Commands
    # EACH has the same effect and sematic as SCAN,
    # but it is easy to use with block.
    #
    # **Options**:
    # see SCAN
    #
    # **Return value**: Nil
    #
    # Example:
    #
    # ```
    # redis.each { |key| p key }
    # redis.each(match: "foo:*") { |key| p key }
    # redis.each(count: 1000) { |key| p key }
    # ```
    
    def each(match = "*", count = 1000)
      idx = 0
      while true
        idx, keys = scan(idx, match, count)
        unless idx.is_a?(String)
          raise "scan failed due to invalid idx: expected String but got `#{idx.class}'"
        end
        idx = idx.to_i
        unless keys.is_a?(Array)
          raise "scan failed due to invalid keys: expected Array but got `#{keys.class}'"
        end
        keys.each do |key|
          yield key.to_s
        end
        break if idx == 0
      end        
    end
  end
end
