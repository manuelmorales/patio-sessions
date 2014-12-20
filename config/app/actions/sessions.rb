let :show do
  Class.new(SessionsController::Show).tap do |action|
    action.sessions_repo { root.repos.sessions }
    action.not_found_exception { root.exceptions.not_found.get_obj }
    action.serializer { root.serializers.sessions }
  end
end

let :update do
  Class.new(SessionsController::Update).tap do |action|
    action.sessions_repo { root.repos.sessions }
  end
end

