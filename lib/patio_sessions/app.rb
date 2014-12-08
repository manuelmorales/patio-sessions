require 'hashie' 
module PatioSessions
  class AppBase
    def let name, &block
      define_singleton_method "#{name}=" do |value|
        eval "@#{name} = value"
      end

      define_singleton_method name do
        eval "@#{name} ||= block.call"
      end
    end

    def section name, &block
      let name do
        self.class.new.tap { |a| block.call a }
      end
    end

    def actions
      @actions ||= Hashie::Mash.new.tap do |h|
        h.sessions!.show = SessionsController::Show
        h.sessions!.show.sessions_repo = Resolver.new { repos.sessions }
        h.sessions!.show.not_found_exception { exceptions.not_found }
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

  class App
    def self.new
      app = AppBase.new

      app.section :repos do |repos|
        repos.let :sessions do
          SessionsMemoryRepo.new.tap do |r|
            r.not_found_exception { app.exceptions.not_found }
          end
        end
      end

      app
    end
  end
end
