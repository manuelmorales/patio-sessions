require 'bundler'
require 'yaml'
require 'benchmark'

config_file = 'config/bundler.yml'

environment = if ENV['RACK_ENV']
                ENV['RACK_ENV']
              elsif File.exist? config_file
                YAML.load(File.read(config_file))['env'] || 
                  raise("\"env\" not defined within #{config_file}")
              else
                'development'
              end

bundler_envs = [:default]
bundler_envs << environment.to_sym
bundler_envs << :development if environment.to_s == 'test'

begin
  $stdout.print "Loading Bundler environments #{bundler_envs.join(", ")}"
  bm = Benchmark.measure { |x| Bundler.setup(*bundler_envs) }
  $stdout.print ": loaded in #{bm.total.round(3)}s\n"
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Try running "bundle install"'
  exit 1
end

require_relative File.dirname(__FILE__) + '/../lib/patio_sessions'

