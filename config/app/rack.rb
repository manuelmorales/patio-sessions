let :rack do
  require 'lotus-router'

  Lotus::Router.new.tap do |r|
    r.get '/admin/info', to: RackInfo
    r.get '/sessions/:id(.:format)', to: Resolver.new { self.actions.sessions.show }
    r.put '/sessions/:id(.:format)', to: Resolver.new { self.actions.sessions.update }
  end
end
