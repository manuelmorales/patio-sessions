module PatioSessions
  class Resolver < Delegator
    require 'sourcify'

    def initialize &block
      @block = block
    end

    def __getobj__
      @block.call
    end

    def inspect
      "#{@block.to_source} @ #{resolver_bound.inspect}"
    end

    def resolver_bound
      @block.binding.eval('self')
    end
  end
end
