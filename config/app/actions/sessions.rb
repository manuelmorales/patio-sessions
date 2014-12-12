sessions.let :show do
  SessionsController::Show.tap do |a|
    a.sessions_repo { app.repos.sessions }
    a.not_found_exception { app.exceptions.not_found }
  end
end
