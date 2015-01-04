module PatioSessions
  module App
    Configuration = Proc.new do

      tool :server do |serv|
        opts = YAML.load File.read 'config/server-defaults.yml'
        opts.merge! YAML.load File.read 'config/server.yml' if File.exist?('config/server.yml')
        opts
      end

      tool :redis do |redis|
        opts = YAML.load File.read 'config/redis-defaults.yml'
        opts.merge! YAML.load File.read 'config/redis.yml' if File.exist?('config/redis.yml')
        opts
      end

      # TODO: symbolize keys
    end
  end
end
