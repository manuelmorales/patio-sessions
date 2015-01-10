module PatioSessions
  class App
    Rack = Proc.new do |root|
      actions = root.actions.sessions

      require 'lotus-router'

      Lotus::Router.new.tap do |r|
        r.get '/admin/info', to: RackInfo
        r.get '/sessions/:id(.:format)', to: MiniObject::Resolver.new { actions.show }
        r.put '/sessions/:id(.:format)', to: MiniObject::Resolver.new { actions.update }
      end
    end
  end
end
