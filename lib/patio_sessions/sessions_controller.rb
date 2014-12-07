module PatioSessions
  class SessionsController
    require 'injectable'

    class Show
      include Injectable
      extend Forwardable

      cattr_injectable :not_found_exception
      def_delegator :'self.class', :not_found_exception

      def self.call env
        new.call env
      end

      def call env
        @env = env
        begin
          action
          render
        rescue not_found_exception => e
          message = "Could not find session with id #{e.id}"
          body error_code: :not_found, error_message: message
          status 404
          render
        end
      end

      def self.sessions_repo
        @sessions_repo || raise('No repo setup yet')
      end

      def self.sessions_repo= repo
        @sessions_repo = repo
      end

      private

      def action
        session = sessions_repo.find(session_id)
        body id: session.id
      end

      def sessions_repo
        self.class.sessions_repo
      end

      def session_id
        env['router.params'][:id]
      end

      NULL = Object.new

      def body value = NULL
        if value == NULL
          @body
        else
          @body = value
        end
      end

      def header key, value = NULL
        if value == NULL
          headers[key]
        else
          headers[key] = value
        end
      end

      def headers
        @headers ||= {'Content-Type' => 'application/json'}
      end

      def status value = NULL
        if value == NULL
          @status ||= 200
        else
          @status = value
        end
      end

      def render
        [status, headers, [body.to_json]]
      end

      def env
        @env
      end
    end
  end
end

