let :sessions do
  serializer = Object.new

  serializer.instance_eval do
    def session session
      {
        :id => session.id,
      }
    end
  end

  serializer
end
