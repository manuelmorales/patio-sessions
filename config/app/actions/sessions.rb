let :show do
  factory = Object.new

  factory.instance_eval do
    extend Injectable

    cattr_injectable :sessions_repo
    cattr_injectable :not_found_exception
    cattr_injectable :serializer

    def call *args
      new.call *args
    end

    def new
      SessionsController::Show.new do |a|
        a.sessions_repo = sessions_repo
        a.not_found_exception = not_found_exception
        a.serializer = serializer
      end
    end
  end

  factory.sessions_repo { root.repos.sessions }
  factory.not_found_exception { root.exceptions.not_found }
  factory.serializer { root.serializers.sessions }

  factory
end

let :update do
  Class.new(SessionsController::Update).tap do |action|
    action.sessions_repo { root.repos.sessions }
  end
end

