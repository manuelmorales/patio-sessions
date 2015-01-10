module PatioSessions
  class App
    class Exceptions < MiniObject::Box

      class NotFound < StandardError
        attr_accessor :id

        def initialize msg, attrs = {}
          super msg
          attrs.each { |k, v| send("#{k}=", v) }
        end
      end
      def self.not_found; NotFound end

    end
  end
end

