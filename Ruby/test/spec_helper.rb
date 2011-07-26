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

api_key = '114D8867A8C4DA4650AA838A7B9F6B01B7D1'
$adzerk = Adzerk.new(api_key)