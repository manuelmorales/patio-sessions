require 'lotus-model'

module PatioSessions
  class Session
    include Lotus::Entity

    attr_accessor :content

    def content
      @content ||= {}
    end
  end
end
