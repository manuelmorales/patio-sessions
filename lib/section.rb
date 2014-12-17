require 'injectable'

class Section
  include Injectable

  attr_accessor :parent
  attr_accessor :name

  def initialize opts ={}, &block
    super()

    opts.each do |k,v|
      send "#{k}=", v
    end

    instance_exec self, &block if block
  end

  def section name, &block
    let name do
      self.class.new(name: name).tap do |a|
        a.parent = self
        a.name = name
        block.call a if block
      end
    end
  end

  def eval_file path
    instance_eval File.read(path), path
  end

  def inspect
    "< #{name} >"
  end

  alias to_s inspect

  def ancestors
    parent ? parent.path : []
  end

  def path
    ancestors << self
  end

  def root
    path.first
  end

  private

  def class_name
    self.class.name || self.class.ancestors.detect(&:name).name
  end
end

