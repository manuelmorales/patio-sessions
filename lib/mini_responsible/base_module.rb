module MiniResponsible
  module BaseModule
    module ClassMethods
      def call env
        new.call env
      end
    end

    def self.included klass
      klass.class_eval do
        extend ClassMethods
      end
    end

    def call env
      @env = env
      action
    end

    private

    def action
      raise NotImplementedError.new
    end

    def response
      @response ||= Response.new
    end

    def env
      @env
    end
  end
end
