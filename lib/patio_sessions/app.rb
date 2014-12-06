require 'hashie'

module PatioSessions
  class App
    def actions
      @actions ||= Hashie::Mash.new.tap do |h|
        h.sessions!.show = SessionsController::Show
        h.sessions!.show.sessions_repo = repos.sessions
      end
    end

    def repos
      @repos ||= Hashie::Mash.new.tap do |h|
        h.sessions = SessionsMemoryRepo.new
      end
    end

    def rack
      RackApp
    end
  end
end
