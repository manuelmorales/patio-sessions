require 'lotus/controller'

module PatioSessions
  class SessionsController
    class Show
      def call env
        session = sessions_repo.find(env['router.params'][:id])
        body = {id: session.id}.to_json
        headers = {'Content-Type' => 'application/json'}
        status = 200
        [status, headers, [body]]
      end

      def sessions_repo
        @sessions_repo ||= Object.new.tap do |repo|
          repo.instance_eval do
            def find id
              OpenStruct.new id: id
            end
          end
        end
      end
    end
  end
end

