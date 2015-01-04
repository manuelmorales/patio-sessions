module PatioSessions
  module App
    require 'mini_object'
    include MiniObject

    Dir.glob("#{PatioSessions.lib_path}/patio_sessions/app/*.rb") do |path|
      require path
    end

    def self.new_base_toolbox
      Toolbox.new :root do |root|
        box :repos, &Repos
        box :stores, &Stores
        box :mappers, &Mappers
        box :exceptions, &Exceptions
        box :actions do
          box :sessions, &SessionsActions
        end
        box :serializers, &Serializers
        box :config, &Configuration
        tool :rack, &Rack
      end
    end

    def self.new
      new_base_toolbox
    end
  end
end

