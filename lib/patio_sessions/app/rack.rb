module PatioSessions
  module App
    Rack = Proc.new do
      require 'lotus-router'

      Lotus::Router.new.tap do |r|
        r.get '/admin/info', to: RackInfo
        r.get '/sessions/:id(.:format)', to: Resolver.new { root.actions.sessions.show }
        r.put '/sessions/:id(.:format)', to: Resolver.new { root.actions.sessions.update }
      end
    end
  end
end
