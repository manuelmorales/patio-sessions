require 'lotus/controller'

module PatioSessions
  class SessionsController
    class Show
      def call env
        session = sessions_repo.find(env['router.params'][:id])

        body id: session.id
        header 'Content-Type', 'application/json'

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
        @headers ||= {}
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
    end
  end
end

