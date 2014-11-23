require_relative 'spec_helper'

ENV['RACK_ENV'] ||= 'test'
require 'rack/test'
include Rack::Test::Methods

lib_path = File.expand_path(File.dirname(__FILE__) + '/../lib')
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

