module PatioSessions
  class App
    class Serializers < Box

      def sessions
        @sessions ||= Inline.new do
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
