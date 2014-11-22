require 'bundler'
require 'yaml'

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
  $stdout.puts "Loading Bundler environments #{bundler_envs.inspect}"
  Bundler.setup(*bundler_envs)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Try running "bundle install"'
  exit 1
end

root_path = File.expand_path(File.dirname(__FILE__) + '/..')
lib_path = root_path + '/lib'
$LOAD_PATH.unshift(root_path) unless $LOAD_PATH.include?(root_path)
$LOAD_PATH.unshift(lib_path) unless $LOAD_PATH.include?(lib_path)

require 'patio_sessions'

