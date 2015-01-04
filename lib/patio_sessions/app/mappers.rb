module PatioSessions
  module App
    Mappers = Proc.new do

      tool :transparent do
        Inline.new do
          def load x; x; end
          def dump x; x; end
        end
      end

      tool :generic do
        require 'yaml'
        YAML
      end

    end
  end
end

