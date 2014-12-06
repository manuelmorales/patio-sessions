module PatioSessions
  class SessionsRepo
    def find id
      store[id]
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
