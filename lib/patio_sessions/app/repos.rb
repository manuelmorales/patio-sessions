module PatioSessions
  class App
    class Repos < MiniObject::Box
      attr_accessor :root
      attr_injectable :sessions

      def initialize root
        @root = root
        sessions &default_sessions_definition
      end

      private

      def default_sessions_definition
        Proc.new do
          @sessions_repo ||= SessionsRepo.new.tap do |r|
            r.not_found_exception { root.exceptions.not_found }
            r.store { root.stores.default }
            r.mapper { root.mappers.generic }
          end
        end
      end

    end
  end
end
