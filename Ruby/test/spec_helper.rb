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

api_key = 'yourApiKey'
$adzerk = Adzerk.new(api_key)