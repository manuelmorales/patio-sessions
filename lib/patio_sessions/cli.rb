require_relative'../../config/environment'
require 'mini_cli'

module PatioSessions
  class Cli < MiniCli::Base
    private

    def puma_args
      ['-p', app.config.server['port'].to_s]
    end

    def app
      @app = App.new
    end
  end
end
