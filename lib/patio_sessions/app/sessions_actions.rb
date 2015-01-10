module PatioSessions
  class App
    class SessionsActions < MiniObject::Box
      attr_accessor :root
      attr_injectable :show
      attr_injectable :update

      def initialize root
        @root = root
        show &default_show
        update &default_update
      end

      private

      def default_show
        lambda do
          @show ||= Class.new(SessionsController::Show).tap do |action|
            action.sessions_repo { root.repos.sessions }
            action.not_found_exception { root.exceptions.not_found }
            action.serializer { root.serializers.sessions }
          end
        end
      end

      def default_update
        lambda do
          @update ||= Class.new(SessionsController::Update).tap do |action|
            action.sessions_repo { root.repos.sessions }
          end
        end
      end

    end
  end
end
