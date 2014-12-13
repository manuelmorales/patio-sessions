let :show do
  SessionsController::ActionFactory.new(SessionsController::Show).tap do |a|
    a.sessions_repo { root.repos.sessions }
    a.not_found_exception { root.exceptions.not_found }
  end
end
