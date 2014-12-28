module PatioSessions
  class RedisStore
    include MiniObject::Injectable

    attr_injectable :redis

    def [] key
      redis.get key
    end

    def []= key, value
      redis.set key, value
    end

    def clear
      redis.flushdb
    end
  end
end
