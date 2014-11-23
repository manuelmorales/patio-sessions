require 'lotus/router'

module PatioSessions
  RackApp = Lotus::Router.new do
    get '/admin/info', to: RackInfo
  end
end

