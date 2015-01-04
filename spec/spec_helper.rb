ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'
include PatioSessions

require 'rspec'

require'pry'

module TestApp
  def patio_app
    test_app
  end

  def test_app
    @patio_app ||= App.new.tap do |app|
      app.stores.tool(:default){ app.stores.memory }
    end
  end

  def integration_app
    @integration_app ||= App.new.tap do |app|
      app.stores.tool(:redis).define(:after_connect) { |store| store.clear }
    end
  end
end

RSpec.configure do |c|
  c.color = true
  c.include TestApp
end

