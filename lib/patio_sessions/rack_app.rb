require 'lotus/router'
require 'lotus/controller'

module PatioSessions
  class Show
    include Lotus::Action
    accept :json
    configuration.default_format :json

    def call(params)
      self.body = '{}'
    end
  end

  RackApp = Lotus::Router.new do
    get '/admin/info', to: RackInfo
    get '/sessions/:id', to: Show
  end
end

