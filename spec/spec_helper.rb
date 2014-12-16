ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'
include PatioSessions

require 'rspec'

def pry
  require'pry'
  binding.pry
end

module TestApp
  def patio_app
    test_app
  end

  def test_app
    @patio_app ||= App.new.tap do |app|
      app.stores.let(:default){ app.stores.memory }
    end
  end

  def integration_app
    App.new
  end
end

RSpec.configure do |c|
  c.color = true
  c.include TestApp
  c.after :each do
    patio_app.stores.default.clear
  end
end

