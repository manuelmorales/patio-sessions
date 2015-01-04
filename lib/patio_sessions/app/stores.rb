module PatioSessions
  module App
    Stores = Proc.new do

      tool :memory do
        {}
      end

      tool :default do
        root.stores.memory
      end

      tool :redis do
        define(:connection_config) { root.config.redis }
        define(:after_connect) { } # template method

        RedisStore.new.tap do |r|
          require 'redis'
          r.redis = Redis.new connection_config
          after_connect r
        end
      end

    end
  end
end
