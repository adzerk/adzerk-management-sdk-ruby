require "rspec"
require "json"
require "net/http"
$:.push File.expand_path("../lib", __FILE__)
require "adzerk"

API_KEY = ENV['ADZERK_API_KEY']
raise "The ADZERK_API_KEY environment variable must be set." unless API_KEY

API_HOST = ENV['ADZERK_API_HOST'] || 'https://api.adzerk.net/v1/'
# $adzerk = Adzerk.new(API_KEY)

RSpec.configure do |config|
  config.color = true
end

