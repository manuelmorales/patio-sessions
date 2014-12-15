require 'hashie' 
require 'section'

module PatioSessions
  class App < Section
    class AppSection < Section
      include PatioSessions
    end

    def self.new
      AppSection.new name: 'app' do |root|
        root.section :actions do |actions|
          actions.section :sessions do |sessions|
            sessions.eval_file 'config/app/actions/sessions.rb'
          end
        end

        root.section :repos do |repos|
          repos.eval_file 'config/app/repos.rb'
        end

        root.section :stores do |repos|
          repos.eval_file 'config/app/stores.rb'
        end

        root.section :mappers do |repos|
          repos.eval_file 'config/app/mappers.rb'
        end

        root.section :repos do |repos|
          repos.eval_file 'config/app/repos.rb'
        end

        root.section :exceptions do |exceptions|
          exceptions.eval_file 'config/app/exceptions.rb'
        end

        root.eval_file 'config/app/rack.rb'

        root.section :serializers do |serializers|
          serializers.eval_file 'config/app/serializers.rb'
        end
      end
    end
  end
end

