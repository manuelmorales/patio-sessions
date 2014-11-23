require 'lotus/controller'

module PatioSessions
  class SessionsController
    include Lotus::Controller
    configuration.default_format :json

    action 'Show' do
      def call(params)
        self.body = '{}'
      end
    end
  end
end

