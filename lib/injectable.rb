module Injectable
  NULL = Object.new

  def initialize &block
    super
    instance_exec self, &block if block
  end

  def self.included klass
    klass.extend self
  end

  def self.getsetter_definition_for name
    lambda do |value = NULL, &block|
      if block
        if value == NULL || value == nil
          instance_variable_set("@#{name}_proc", block)
        else
          send("#{name}=", value)
        end
      else
        if value == NULL
          instance_variable_get("@#{name}_proc").call
        else
          send("#{name}=", value)
        end
      end
    end
  end

  def self.setter_definition_for name
    lambda do |value|
      instance_variable_set("@#{name}_proc", lambda{ value })
      value
    end
  end

  def cattr_injectable name
    define_singleton_method name, &Injectable.getsetter_definition_for(name)
    define_singleton_method "#{name}=", &Injectable.setter_definition_for(name)
  end

  def attr_injectable name
    define_method name, &Injectable.getsetter_definition_for(name)
    define_method "#{name}=", &Injectable.setter_definition_for(name)
  end
end
