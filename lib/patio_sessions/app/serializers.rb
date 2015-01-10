module PatioSessions
  class App
    class Serializers < MiniObject::Box

      def sessions
        @sessions ||= MiniObject::Inline.new do
          def session session
            {
              :id => session.id,
              :content => session.content,
            }
          end
        end
      end

    end
  end
end
