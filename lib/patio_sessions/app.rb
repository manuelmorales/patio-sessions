require 'hashie' 
module PatioSessions
  class Section
    attr_accessor :root
    attr_accessor :name

    def initialize &block
      instance_exec self, &block if block
    end

    def let name, &block
      define_singleton_method "#{name}=" do |value|
        eval "@#{name} = value"
      end

      define_singleton_method name do
        eval "defined?(@#{name}) ? @#{name} : @#{name} = block.call(self)"
      end
    end

    def section name, &block
      let name do
        self.class.new.tap do |a|
          a.root = root || self
          a.name = name
          block.call a if block
        end
      end
    end

    def eval_file path
      eval File.read(path)
    end

    def inspect
      "#<section:#{name}>"
    end
  end

  class App < Section
    def self.new
      Section.new do |root|
        root.section :actions do |actions|
          actions.section :sessions do |sessions|
            sessions.eval_file 'config/app/actions/sessions.rb'
          end
        end

        root.section :repos do |repos|
          repos.eval_file 'config/app/repos.rb'
        end

        root.section :exceptions do |exceptions|
          exceptions.eval_file 'config/app/exceptions.rb'
        end

        root.eval_file 'config/app/rack.rb'
      end
    end
  end
end
