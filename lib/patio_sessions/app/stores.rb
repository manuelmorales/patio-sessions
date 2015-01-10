module PatioSessions
  class App
    class Stores < MiniObject::Box
      attr_accessor :root
      attr_injectable :default

      def initialize root
        @root = root
      end

      def memory
        @memory ||= {}
      end

      def redis
        @redis ||= RedisStore.new.tap do |r|
          require 'redis'
          r.redis = Redis.new connection_config
          on_redis_connect.call r
        end
      end

      def on_redis_connect &block
        if block
          @on_redis_connect = block
        else
          @on_redis_connect ||= Proc.new { }
        end
      end

      private

      def connection_config
        root.config.redis
      end
    end
  end
end
