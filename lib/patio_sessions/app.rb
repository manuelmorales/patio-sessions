require 'hashie' 
module PatioSessions
  class AppBase
    attr_accessor :root

    def initialize &block
      instance_exec self, &block if block
    end

    def let name, &block
      define_singleton_method "#{name}=" do |value|
        eval "@#{name} = value"
      end

      define_singleton_method name do
        eval "defined?(@#{name}) ? @#{name} : @#{name} = block.call(self)"
      end
    end

    def section name, &block
      let name do
        self.class.new.tap do |a|
          a.root = root || self
          block.call a if block
        end
      end
    end

    def from_hash hash
      hash.each do |k,v|
        case v
        when Hash then
          section k
          send(k).from_hash v
        when String then 
          section(k){ eval File.read v }
        else
          raise
        end
      end
    end

    def eval_file path
      eval File.read(path)
    end
  end

  class App < AppBase
    def self.new
      AppBase.new do |root|
        from_hash(
          {
            :exceptions => {},
          }
        )

        root.section :actions do |actions|
          actions.section(:sessions) do |sessions|
            sessions.eval_file 'config/app/actions/sessions.rb'
          end
        end

        root.section :repos do |repos|
          repos.eval_file 'config/app/repos.rb'
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
            r.get '/sessions/:id(.:format)', to: Resolver.new { root.actions.sessions.show }
          end
        end
      end
    end
  end
end
