require 'lotus/router'

module PatioSessions
  RackApp = Lotus::Router.new do
    get '/admin/info', to: RackInfo
    get '/sessions/:id', to: SessionsController::Show
  end
end

