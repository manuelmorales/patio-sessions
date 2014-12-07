module Injectable
  NULL = Object.new

  def self.included klass
    klass.extend ClassMethods
  end

  module ClassMethods
    def injectable name
      define_method name do |value = NULL, &block|
        if value == NULL
          if block
            instance_variable_set("@#{name}_proc", block)
          else
            instance_variable_get("@#{name}_proc").call
          end
        else
          if value == nil
            if block
              instance_variable_set("@#{name}_proc", block)
            else
              instance_variable_set("@#{name}_proc", lambda{ value })
            end
          else
            instance_variable_set("@#{name}_proc", lambda{ value })
          end
          value || block
        end
      end

      define_method "#{name}=" do |value, &block|
        instance_variable_set("@#{name}_proc", lambda{ value })
      end
    end
  end
end
