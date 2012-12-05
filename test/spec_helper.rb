require "rspec"
require "json"
require "net/http"
$:.push File.expand_path("../lib", __FILE__)
require "adzerk"

API_KEY = ENV['ADZERK_API_KEY'] || 'your_api_key'
# $adzerk = Adzerk.new(API_KEY)

RSpec.configure do |config|
  config.color_enabled = true
end

