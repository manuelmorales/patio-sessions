require 'active_support'

module PatioSessions
  class << self
    def lib_path
      root_path + 'lib'
    end

    def root_path
      Pathname.new File.expand_path "#{File.dirname(__FILE__)}/.."
    end

    def setup_load_paths
      $LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
      $LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

      Dir.glob("#{lib_path}/patio_sessions/**") do |path|
        base = Pathname.new(path).basename.sub_ext''
        autoload ActiveSupport::Inflector.camelize(base), path
      end

      VERSION # to force laoding this one
    end
  end

  setup_load_paths

  class << self
    def new
      App.new
    end
  end
end
