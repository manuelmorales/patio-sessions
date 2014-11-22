require 'thor'
require 'puma/cli'

module PatioSessions
  class Cli < Thor
    desc 'test', 'run the rspec tests'
    def test *args
      args = ['spec'] if args.empty?

      require_relative '../../spec/spec_helper'
      RSpec::Core::Runner.run(args)
    end

    desc 'console', 'pry console'
    def console
      invoke :environment
      require'pry'
      Pry.start PatioSessions
    end

    desc 'autotest', ''
    def autotest
      system('bundle exec guard')
    end

    desc 'start', 'runs the HTTP server'
    def start
      invoke :environment
      Puma::CLI.new([]).run
    end

    desc 'environment', 'loads environment.rb'
    def environment
      require_relative'../../config/environment'
    end
  end
end
