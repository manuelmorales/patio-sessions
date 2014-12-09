require 'hashie' 
module PatioSessions
  class AppBase
    def initialize &block
      instance_exec self, &block if block
    end

    def let name, &block
      define_singleton_method "#{name}=" do |value|
        eval "@#{name} = value"
      end

      define_singleton_method name do
        eval "defined?(@#{name}) ? @#{name} : @#{name} = block.call"
      end
    end

    def section name, &block
      let name do
        self.class.new.tap {|a| a.send(:instance_exec, a, &block) }
      end
    end
  end

  class App
    def self.new
      AppBase.new do |app|
        section :repos do
          let :sessions do
            SessionsMemoryRepo.new do
              not_found_exception { app.exceptions.not_found }
            end
          end
        end

        section :actions do
          section :sessions do
            let :show do
              SessionsController::Show.tap do |a|
                a.sessions_repo { app.repos.sessions }
                a.not_found_exception { app.exceptions.not_found }
              end
            end
          end
        end

        let :rack do
          require 'lotus-router'
          Lotus::Router.new.tap do |r|
            r.get '/admin/info', to: RackInfo
            r.get '/sessions/:id(.:format)', to: Resolver.new { actions.sessions.show }
          end
        end

        section :exceptions do
          let :not_found do
            Class.new(StandardError) do
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
  end
end
