require 'hashie'

module PatioSessions
  class App
    def actions
      @actions ||= Hashie::Mash.new.tap do |h|
        h.sessions!.show = SessionsController::Show
        h.sessions!.show.sessions_repo = Resolver.new { repos.sessions }
        h.sessions!.show.not_found_exception { exceptions.not_found }
      end
    end

    def repos
      @repos ||= Hashie::Mash.new.tap do |h|
        h.sessions = SessionsMemoryRepo.new
        h.sessions.not_found_exception { exceptions.not_found }
      end
    end

    def rack
      require 'lotus-router'
      @rack ||= Lotus::Router.new.tap do |r|
        r.get '/admin/info', to: RackInfo
        r.get '/sessions/:id(.:format)', to: Resolver.new { actions.sessions.show }
      end
    end

    def exceptions
      @exceptions ||= Hashie::Mash.new.tap do |h|
        h.not_found = Class.new(StandardError) do
          attr_accessor :id

          def initialize msg, attrs = {}
            super msg
            attrs.each { |k, v| send("#{k}=", v) }
          end
        end
      end
    end
  end
end
