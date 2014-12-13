module PatioSessions
  class SessionsController
    require 'injectable'

    class ActionFactory
      include Injectable

      attr_injectable :not_found_exception
      attr_injectable :sessions_repo

      def initialize klass
        @klass = klass
      end

      def call env
        @klass.new.tap do |instance|
          instance.not_found_exception = not_found_exception
          instance.sessions_repo = sessions_repo
        end.call env
      end
    end

    class Show
      include Injectable

      attr_accessor :not_found_exception
      attr_accessor :sessions_repo

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

      private

      def action
        session = sessions_repo.find(session_id)
        body session_serializer.serialize(session)
      end

      def session_serializer
        Object.new.tap do |o|
          o.instance_eval do
            def serialize session
              {
                :id => session.id,
              }
            end
          end
        end
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

