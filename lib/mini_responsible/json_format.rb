module MiniResponsible
  class JsonFormat
    def content_type
      'application/json'
    end

    def dump body
      JSON.dump body if body
    end
  end
end
