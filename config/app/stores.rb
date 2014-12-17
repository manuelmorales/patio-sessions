let :redis do
  Lazy.new do
    Inline.new do
      cattr_injectable :redis

      redis { Lazy.new { require'redis'; Redis.new } }

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
end

let :memory do
  Lazy.new { {} }
end

let :default do
  root.stores.redis
end
