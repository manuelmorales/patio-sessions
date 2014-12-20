require 'injectable'

class HashSection
  # include Injectable

  attr_accessor :parent
  attr_accessor :name

  def initialize opts ={}, &block
  #   super()

    opts.each do |k,v|
      send "#{k}=", v
    end

  #   instance_exec self, &block if block
  end

  def section name, &block
    unless sec = dependencies[name]
      sec = HashSection.new name: name, parent: self
      dependencies[name] = sec
    end

    block.call dependencies[name] if block
    sec
  end

  def let name, &block
    dependencies[name] = Lazy.new &block
  end

  private

  def dependencies
    @dependencies ||= {}
  end

  def method_missing name, *args
    dependencies[name] || super
  end

  def respond_to_missing? name, *args
    !!dependencies[name]
  end

  public

  # hash + method missing
  # hash + method definition
  #
  # hash of lambdas
  # hash of objects themselves

  # def section name, &block
  #   if children_names.include? name 
  #     block.call send(name)
  #   else
  #     let name do
  #       self.class.new(name: name).tap do |a|
  #         a.parent = self
  #         a.name = name
  #         block.call a if block
  #       end
  #     end
  #     children_names << name
  #   end

  #   name
  # end

  # def children_names
  #   @children_names ||= []
  # end

  # def children
  #   children_names.map{|n| send n }
  # end

  # def eval_file path
  #   instance_eval File.read(path), path
  # end

  # def inspect depth = 0
  #   out = ''
  #   out << "\n" if depth == 0 && children.any?
  #   out << "  " * depth + to_s

  #   children.each do |child|
  #     out << "\n" << child.inspect(depth + 1)
  #   end

  #   out
  # end

  # def to_s
  #   if root?
  #     "<< #{name} >>"
  #   else
  #     "< #{name} >"
  #   end
  # end

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

  # private

  # def class_name
  #   self.class.name || self.class.ancestors.detect(&:name).name
  # end
end

