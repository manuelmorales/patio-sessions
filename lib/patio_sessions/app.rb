require 'hashie'

module PatioSessions
  class App
    def actions
      @actions ||= Hashie::Mash.new.tap do |h|
        h.sessions!.show = SessionsController::Show
        h.sessions!.show.sessions_repo = Resolver.new { repos.sessions }
      end
    end

    def repos
      @repos ||= Hashie::Mash.new.tap do |h|
        h.sessions = SessionsMemoryRepo.new
      end
    end

    def rack
      require 'lotus-router'
      @rack ||= Lotus::Router.new.tap do |r|
        r.get '/admin/info', to: RackInfo
        r.get '/sessions/:id(.:format)', to: Resolver.new { actions.sessions.show }
      end
    end
  end
end
