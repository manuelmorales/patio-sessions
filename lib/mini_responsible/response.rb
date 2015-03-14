module MiniResponsible
  class Response
    attr_accessor :body
    attr_accessor :headers
    attr_accessor :status
    attr_accessor :format

    def initialize opts = {}
      @format = opts.fetch(:format) { JsonFormat.new }
      @headers = {}
      @status = 200
    end

    def to_rack
      headers['Content-Type'] = format.content_type if body
      Rack::Response.new [format.dump(body)], status, headers
    end

    def to_a
      to_rack.to_a
    end
    alias to_ary to_a
  end
end
