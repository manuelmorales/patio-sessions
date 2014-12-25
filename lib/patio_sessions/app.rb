require 'hashie' 
require 'hash_section'

module PatioSessions
  module App
    def self.new
      HashSection.new name: 'app' do |root|
        root.section :actions do |actions|
          actions.section :sessions do |sessions|
            sessions.eval_file 'config/app/actions/sessions.rb'
          end
        end

        root.section :repos do |s|
          s.eval_file 'config/app/repos.rb'
        end

        root.section :stores do |s|
          s.eval_file 'config/app/stores.rb'
        end

        root.section :mappers do |s|
          s.eval_file 'config/app/mappers.rb'
        end

        root.section :exceptions do |s|
          s.eval_file 'config/app/exceptions.rb'
        end

        root.eval_file 'config/app/rack.rb'

        root.section :serializers do |s|
          s.eval_file 'config/app/serializers.rb'
        end
      end
    end
  end
end

