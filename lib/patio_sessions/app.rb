require 'mini_object'

module PatioSessions
  class App < MiniObject::Box
    Dir.glob("#{PatioSessions.lib_path}/patio_sessions/app/*.rb") do |path|
      require path
    end

    def repos
      @repos ||= Repos.new self
    end

    def stores
      @stores ||= Stores.new(self).tap do |stores|
        stores.default { stores.redis }
      end
    end

    def mappers
      @mappers ||= Mappers.new
    end

    def exceptions
      Exceptions
    end

    def rack
      @rack ||= Rack.call self
    end

    def config
      @config ||= Configuration.new
    end

    def actions
      @actions ||= lambda do

        root = self

        MiniObject::Inline.new :actions, root: self do |actions|
          def sessions
            @sessions ||= SessionsActions.new root
          end
        end
      end.call
    end

    def serializers
      @serializers ||= Serializers.new
    end

    singleton_class.send :alias_method, :new_base_toolbox, :new
  end
end

