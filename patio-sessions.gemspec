$:.push File.expand_path('../lib', __FILE__)
require 'patio_sessions/version'

Gem::Specification.new do |s|
  s.name        = 'patio-sessions'
  s.version     = PatioSessions::VERSION
  s.authors     = ['Manuel Morales']
  s.email       = ['manuelmorales@gmail.com']
  s.homepage    = nil
  s.summary     = s.description = 'Provides Sessions service'
  s.license     = 'Copyright Manuel Morales 2014'

  s.files = Dir['{lib,config,views}/**/*', 'cli', 'README.md']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'puma'
  s.add_dependency 'thor'
  s.add_dependency 'lotus-router'
  s.add_dependency 'lotus-controller'

  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-byebug'
  s.add_development_dependency 'guard'
  s.add_development_dependency 'guard-rspec'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rack-test'
end
