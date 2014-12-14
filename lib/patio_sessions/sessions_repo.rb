module PatioSessions
  class SessionsRepo
    require 'injectable'
    include Injectable

    attr_injectable :not_found_exception
    attr_injectable :store

    def find id
      store[id] || raise(not_found_exception.new "Could not find session #{id}", id: id)
    end

    def save session
      store[session.id] = session
    end
  end
end
