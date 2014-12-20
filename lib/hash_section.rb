require 'injectable'

module PatioSessions
  class HashSection
    # include Injectable

    attr_accessor :parent
    attr_accessor :name

    def initialize opts ={}, &block
      opts.each do |k,v|
        send "#{k}=", v
      end

      instance_exec self, &block if block
    end

    def section name, &block
      unless sec = sections[name]
        sec = HashSection.new name: name, parent: self
        sections[name] = sec
      end

      block.call sections[name] if block
      sec
    end

    def let name, &block
      sections[name] = Lazy.new &block
    end

    private

    def sections
      @sections ||= {}
    end

    def method_missing name, *args
      if value = sections[name]
        value
      elsif match = name.to_s.match(/(.*)=$/)
        let(match[1].to_sym) { args.first }
      else
        super
      end
    end

    def respond_to_missing? name, *args
      !!sections[name]
    end

    public

    def children
      sections.keys.map{|n| send n }
    end

    def eval_file path
      instance_eval File.read(path), path
    end

    def inspect
      out = "\n" + to_s

      children.each do |child|
        out << child.inspect.gsub(/\n/,"\n  ")
      end

      out
    end

    def to_s
      if root?
        "<< #{name} >>"
      else
        "< #{name} >"
      end
    end

    def ancestors
      parent ? parent.path : []
    end

    def path
      ancestors << self
    end

    def root
      path.first
    end

    def root?
      !parent
    end
  end
end
