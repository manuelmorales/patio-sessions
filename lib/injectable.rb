module Injectable
  NULL = Object.new

  def self.included klass
    klass.extend self
  end

  def cattr_injectable name
    define_singleton_method name do |value = NULL, &block|
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

    define_singleton_method "#{name}=" do |value|
      instance_variable_set("@#{name}_proc", lambda{ value })
      value
    end
  end

  def attr_injectable name
    define_method name do |value = NULL, &block|
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

    define_method "#{name}=" do |value|
      instance_variable_set("@#{name}_proc", lambda{ value })
      value
    end
  end
end
