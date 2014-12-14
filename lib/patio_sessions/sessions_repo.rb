module PatioSessions
  class SessionsRepo
    require 'injectable'
    include Injectable

    attr_injectable :not_found_exception

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
