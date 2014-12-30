module PatioSessions
  module App
    SessionsActions = Proc.new do

      tool :show do
        Class.new(SessionsController::Show).tap do |action|
          action.sessions_repo { root.repos.sessions }
          action.not_found_exception { root.exceptions.not_found }
          action.serializer { root.serializers.sessions }
        end
      end

      tool :update do
        Class.new(SessionsController::Update).tap do |action|
          action.sessions_repo { root.repos.sessions }
        end
      end

    end
  end
end
