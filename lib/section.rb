require 'injectable'

class Section
  include Injectable

  attr_accessor :root
  attr_accessor :name

  def initialize opts ={}, &block
    opts.each do |k,v|
      send "#{k}=", v
    end

    instance_exec self, &block if block
  end

  def section name, &block
    let name do
      self.class.new(name: name).tap do |a|
        a.root = root || self
        a.name = name
        block.call a if block
      end
    end
  end

  def eval_file path
    eval File.read(path), binding, path
  end

  def inspect
    "#<#{name}:#{class_name}:0x#{'%x' % (object_id << 1)}>"
  end

  private

  def class_name
    self.class.name || self.class.ancestors.detect(&:name).name
  end
end

