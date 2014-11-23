require 'lotus/controller'

module PatioSessions
  class SessionsController
    class Show
      include Lotus::Action
      accept :json
      configuration.default_format :json

      def call(params)
        self.body = '{}'
      end
    end
  end
end

