require 'bundler/setup'
require './app'
require 'sinatra/activerecord/rake'

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec)
  task default: :spec
rescue LoadError
end
