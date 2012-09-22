require "rspec"
require "json"
require "net/http"
require "../lib/adzerk"
require "../lib/adzerk/site"
require "../lib/adzerk/zone"
require "../lib/adzerk/publisher"
require "../lib/adzerk/channel"
require "../lib/adzerk/campaign"
require "../lib/adzerk/flight"
require "../lib/adzerk/login"
require "../lib/adzerk/reporting"
require "../lib/adzerk/creative"
require "../lib/adzerk/creative_map"
require "../lib/adzerk/advertiser"
require "../lib/adzerk/invitation"
require "../lib/adzerk/priority"
require "../lib/adzerk/channel_site_map"

api_key = ENV["ADZERK_API_KEY"] || 'yourapikey'
$adzerk = Adzerk.new(api_key)

RSpec.configure do |config|
  config.color_enabled = true
end

