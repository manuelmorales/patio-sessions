ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'
include PatioSessions

require 'rspec'
require 'pry'

RSpec.configure do |c|
  c.color = true
end

