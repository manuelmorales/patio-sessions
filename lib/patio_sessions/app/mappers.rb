module PatioSessions
  class App
    class Mappers < Box
      def transparent
        Inline.new do
          def load x; x; end
          def dump x; x; end
        end
      end

      def generic
        require 'yaml'
        YAML
      end
    end
  end
end

