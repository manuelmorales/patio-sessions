require_relative'../../config/environment'
require 'mini_cli'

module PatioSessions
  class Cli < MiniCli::Base
    desc 'start', 'Starts the Puma and any other required thread'
    define_method :start do
      require 'puma/cli'
      Puma::CLI.new(puma_args).run
    end

    private

    def puma_args
      ['-p', app.config.server['port'].to_s]
    end

    def app
      @app = App.new
    end
  end
end
