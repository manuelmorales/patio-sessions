require 'hashie' 
require 'section'

module PatioSessions
  class App < Section
    def self.new
      Section.new name: 'app' do |root|
        root.section :actions do |actions|
          actions.section :sessions do |sessions|
            sessions.eval_file 'config/app/actions/sessions.rb'
          end
        end

        root.section :repos do |repos|
          repos.eval_file 'config/app/repos.rb'
        end

        root.section :exceptions do |exceptions|
          exceptions.eval_file 'config/app/exceptions.rb'
        end

        root.eval_file 'config/app/rack.rb'
      end
    end
  end
end
