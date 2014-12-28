section :server do |serv|
  opts = YAML.load File.read 'config/server-defaults.yml'
  opts.merge! YAML.load File.read 'config/server.yml'

  opts.each do |key, value|
    serv.let(key.to_sym) { value }
  end
end

