let :transparent do
  Inline.new do
    def load x; x; end
    def dump x; x; end
  end
end

let :generic do
  require 'yaml'
  YAML
end

