let :sessions do
  serializer = Object.new

  serializer.instance_eval do
    def session session
      {
        :id => session.id,
        :content => session.content,
      }
    end
  end

  serializer
end
