module PatioSessions
  module App
    Rack = Proc.new do |rack|
      actions = rack.root.actions.sessions

      require 'lotus-router'

      Lotus::Router.new.tap do |r|
        r.get '/admin/info', to: RackInfo
        r.get '/sessions/:id(.:format)', to: Resolver.new { actions.show }
        r.put '/sessions/:id(.:format)', to: Resolver.new { actions.update }
      end
    end
  end
end
