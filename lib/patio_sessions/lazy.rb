module PatioSessions
  class Lazy < Delegator
    def initialize &block
      @block = block
    end

    def __getobj__
      @obj ||= @block.call.tap do |obj|
        tear_up_blocs.each do |name, block|
          block.call obj
        end
      end
    end

    def resolver_bound
      @block.binding.eval('self')
    end

    def on_tear_up name, &block
      tear_up_blocs[name] = block
    end

    private

    def tear_up_blocs
      @tear_up_blocs ||= {}
    end
  end
end
