require 'lotus/router'

module PatioSessions
  class RackApp
    def self.call *args
      lotus_router.call *args
    end

    def self.recognize verb, path, headers = {}
      req = Rack::MockRequest.env_for(path, method: verb.to_s.upcase)
      lotus_router.instance_variable_get(:@router).recognize(req).first.first.route.dest
    end

    private

    def self.lotus_router
      @router ||= Lotus::Router.new do
        get '/admin/info', to: RackInfo
        get '/sessions/:id', to: SessionsController::Show
      end
    end
  end
end

