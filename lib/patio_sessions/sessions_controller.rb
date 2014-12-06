module PatioSessions
  class SessionsController
    class Show
      def self.call env
        new.call env
      end

      def call env
        @env = env
        action
        render
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

      private

      def action
        session = sessions_repo.find(session_id)
        body id: session.id
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

