module PatioSessions
  class Lazy < Delegator
    def initialize &block
      @block = block
    end

    def __getobj__
      @obj ||= @block.call.tap do |obj|
        build_steps.each do |name, block|
          block.call obj
        end
      end
    end

    alias get_obj __getobj__

    def resolver_bound
      @block.binding.eval('self')
    end

    def build_step name, &block
      build_steps[name] = block
    end

    private

    def build_steps
      @build_steps ||= {}
    end
  end
end
