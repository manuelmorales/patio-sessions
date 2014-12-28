describe :redis do |r|
  r.build { RedisStore.new }

  r.build_step(:redis_connection) do |r|
    require'redis'
    r.redis = Redis.new(root.config.redis.get_obj)
  end
end

let :memory do
  {}
end

let :default do
  root.stores.redis
end
