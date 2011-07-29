require "rubygems"
require "rspec"
require "json"
require "net/http"
require "../lib/Adzerk"
require "../lib/adzerk/Site"
require "../lib/adzerk/Publisher"
require "../lib/adzerk/Channel"
require "../lib/adzerk/Campaign"
require "../lib/adzerk/Flight"
require "../lib/adzerk/Login"
require "../lib/adzerk/Reporting"
require "../lib/adzerk/Creative"
require "../lib/adzerk/CreativeMap"
require "../lib/adzerk/Advertiser"

api_key = 'yourapikey'
$adzerk = Adzerk.new(api_key)