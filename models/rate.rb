# Class to implement rate data store model
class Rate
  class << self
    def find(id)
      redis.get(key(id))
    end

    def save(id, rate)
      redis.set(key(id), rate)
    end

    def exists?(partial)
      !redis.keys("#{prefix}:#{partial}:*").empty?
    end

    private

    def redis
      @redis ||= Redis.new(url: ENV['REDIS_URL'])
    end

    def key(id)
      "#{prefix}:#{id}"
    end

    def prefix
      'rate'
    end
  end
end
