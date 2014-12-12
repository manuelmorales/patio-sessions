let :not_found do
  Class.new(StandardError) do
    attr_accessor :id

    def initialize msg, attrs = {}
      super msg
      attrs.each { |k, v| send("#{k}=", v) }
    end
  end
end

