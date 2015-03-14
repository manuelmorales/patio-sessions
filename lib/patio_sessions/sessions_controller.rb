module PatioSessions
  class SessionsController
    require 'injectable'

    module Base
      include MiniObject

      def self.included klass
        klass.class_eval do
          include MiniResponsible::BaseModule
          include Injectable
          extend Forwardable

          cattr_injectable :sessions_repo
          def_delegator :'self.class', :sessions_repo
        end
      end

      private

      def session_id
        env['router.params'][:id]
      end
    end

    class Show
      include Base
      
      cattr_injectable :not_found_exception
      def_delegator :'self.class', :not_found_exception

      cattr_injectable :serializer
      def_delegator :'self.class', :serializer

      private

      def action
        not_found_handled do
          session = sessions_repo.find(session_id)
          response.body = serializer.session(session)
          response
        end
      end

      def not_found_handled
        begin
          yield
        rescue not_found_exception => e
          message = "Could not find session with id #{e.id}"
          response.body = {error_code: :not_found, error_message: message}
          response.status = 404
          response
        end
      end
    end

    class Update
      include Base

      def call env
        @env = env
        action
      end

      private

      def action
        sessions_repo.save Session.new(id: session_id, content: content_from_body)
        response
      end

      def content_from_body
        if request_body && request_body.length > 0
          JSON.parse(request_body, symbolize_names: true)
        end
      end

      def request_body
        @request_body ||= env['rack.input'].read
      end

      def session_id
        env['router.params'][:id]
      end
    end
  end
end


