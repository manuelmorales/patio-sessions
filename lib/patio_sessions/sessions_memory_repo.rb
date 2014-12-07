module PatioSessions
  class SessionsMemoryRepo
    NULL = Object.new

    def not_found_exception value = NULL
      if value == NULL
        if block_given?
          @not_found_exception = yield
        else
          @not_found_exception
        end
      else
        if block_given?
          raise("Both, block and value were given. I don't know which one to pick")
        else
          @not_found_exception = value
        end
      end
    end

    def find id
      store[id] || raise(not_found_exception.new "Could not find session #{id}", id: id)
    end

    def save session
      store[session.id] = session
    end

    private

    def store
      @store ||= {}
    end
  end
end
