require "rspec"
require "json"
require "net/http"
$:.push File.expand_path("../lib", __FILE__)
require "adzerk"

API_KEY = 'EBE6A7D8A49CBA419FAB08AA996E293A14B9'
# $adzerk = Adzerk.new(API_KEY)

RSpec.configure do |config|
  config.color_enabled = true
end

