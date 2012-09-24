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

API_KEY = 'EBE6A7D8A49CBA419FAB08AA996E293A14B9'
# $adzerk = Adzerk.new(API_KEY)

RSpec.configure do |config|
  config.color_enabled = true
end

