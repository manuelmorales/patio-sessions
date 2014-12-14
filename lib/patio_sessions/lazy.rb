module PatioSessions
  class Lazy < Delegator
    def initialize &block
      @block = block
    end

    def __getobj__
      @obj ||= @block.call
    end

    def resolver_bound
      @block.binding.eval('self')
    end
  end
end
