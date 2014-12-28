section :server do |serv|
  opts = YAML.load File.read 'config/server-defaults.yml'
  opts.merge! YAML.load File.read 'config/server.yml' if File.exist?('config/server.yml')

  opts.each do |key, value|
    serv.let(key.to_sym) { value }
  end
end

let :redis do |redis|
  opts = YAML.load File.read 'config/redis-defaults.yml'
  opts.merge! YAML.load File.read 'config/redis.yml' if File.exist?('config/redis.yml')

  opts
end

