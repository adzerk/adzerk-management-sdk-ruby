require "rspec"
require "json"
require "net/http"
$:.push File.expand_path("../lib", __FILE__)
require "adzerk"
require "adzerk/site"
require "adzerk/zone"
require "adzerk/publisher"
require "adzerk/channel"
require "adzerk/campaign"
require "adzerk/flight"
require "adzerk/login"
require "adzerk/reporting"
require "adzerk/creative"
require "adzerk/creative_map"
require "adzerk/advertiser"
require "adzerk/invitation"
require "adzerk/priority"
require "adzerk/channel_site_map"

API_KEY = ENV["ADZERK_API_KEY"] || 'your_api_key'
# $adzerk = Adzerk.new(API_KEY)

RSpec.configure do |config|
  config.color_enabled = true
end

