module PatioSessions
  module App
    Serializers = Proc.new do

      tool :sessions do
        Inline.new do
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
