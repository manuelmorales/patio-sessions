module PatioSessions
  class App
    class Configuration < MiniObject::Box
      def server
        @server ||= YAML.load(File.read 'config/server-defaults.yml').tap do |opts|
          opts.merge! YAML.load File.read 'config/server.yml' if File.exist?('config/server.yml')
        end
      end

      def redis
        @redis ||= YAML.load(File.read 'config/redis-defaults.yml').tap do |opts|
          opts.merge! YAML.load File.read 'config/redis.yml' if File.exist?('config/redis.yml')
        end
      end

      # TODO: symbolize keys
    end
  end
end
