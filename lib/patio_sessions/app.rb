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
      block = Proc.new{ self.class.new } unless block

      let name do
        self.class.new.tap {|a| a.send(:instance_exec, a, &block) }
      end
    end

    def from_hash hash
      hash.each do |k,v|
        section k
        send(k).from_hash v
      end
    end
  end

  class App < AppBase
    def self.new
      AppBase.new do |app|
        from_hash(
          {
            :repos => {},
            :actions => {
              :sessions => {},
            },
            :exceptions => {},
          }
        )

        repos.let :sessions do 
          SessionsMemoryRepo.new do
            not_found_exception { app.exceptions.not_found }
          end
        end

        actions.sessions.let :show do
          SessionsController::Show.tap do |a|
            a.sessions_repo { app.repos.sessions }
            a.not_found_exception { app.exceptions.not_found }
          end
        end

        exceptions.let :not_found do
          Class.new(StandardError) do
            attr_accessor :id

            def initialize msg, attrs = {}
              super msg
              attrs.each { |k, v| send("#{k}=", v) }
            end
          end
        end

        let :rack do
          require 'lotus-router'
          Lotus::Router.new.tap do |r|
            r.get '/admin/info', to: RackInfo
            r.get '/sessions/:id(.:format)', to: Resolver.new { app.actions.sessions.show }
          end
        end
      end
    end
  end
end
