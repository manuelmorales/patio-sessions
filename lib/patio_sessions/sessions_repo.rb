module PatioSessions
  class SessionsRepo
    require 'injectable'
    include Injectable

    attr_injectable :not_found_exception
    attr_injectable :store
    attr_injectable :mapper

    def find id
      mapper.load store[id] || raise(not_found_exception.new "Could not find session #{id}", id: id)
    end

    def save session
      store[session.id] = mapper.dump session
    end
  end
end
