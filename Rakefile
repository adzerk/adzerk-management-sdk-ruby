$LOAD_PATH.unshift(File.dirname(__FILE__) + '/lib')
require "json"
require "net/http"
require "adzerk"

def admin
  client = Adzerk::Client.new(ENV['ADZERK_API_KEY'])
  response = client.get_request('login-diagnostics')
  not response.is_a? Net::HTTPFound
end

begin
  require 'rspec/core/rake_task'
  RSpec::Core::RakeTask.new(:spec) do |t|
    raise "Tests must be run using an API key not associated with an admin" if admin
    t.pattern = 'test/*_spec.rb'
  end
rescue LoadError
end

task :test => :spec
task :default => :spec
