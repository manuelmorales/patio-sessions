module PatioSessions
  class SessionsController
    require 'injectable'

    module Base
      module ClassMethods
        def call env
          new.call env
        end
      end

      def self.included klass
        klass.class_eval do
          extend ClassMethods

          include Injectable
          extend Forwardable

          cattr_injectable :sessions_repo
          def_delegator :'self.class', :sessions_repo
        end
      end

      def call env
        raise NotImplementedError.new
      end

      private

      def action
        raise NotImplementedError.new
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
        [status, headers, [body && body.to_json]]
      end

      def env
        @env
      end
    end

    class Show
      include Base
      
      cattr_injectable :not_found_exception
      def_delegator :'self.class', :not_found_exception

      cattr_injectable :serializer
      def_delegator :'self.class', :serializer

      def call env
        @env = env
        header 'Content-Type', 'application/json'

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
        body serializer.session(session)
      end

      def session_id
        env['router.params'][:id]
      end
    end

    class Update
      include Base

      def call env
        @env = env
        action
        render
      end

      private

      def action
        sessions_repo.save Session.new(id: session_id)
      end

      def session_id
        env['router.params'][:id]
      end
    end
  end
end


