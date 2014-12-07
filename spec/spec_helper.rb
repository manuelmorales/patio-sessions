ENV['RACK_ENV'] = 'test'

require_relative '../config/environment'
include PatioSessions

require 'rspec'

def pry
  require'pry'
  binding.pry
end

RSpec.configure do |c|
  c.color = true
end

