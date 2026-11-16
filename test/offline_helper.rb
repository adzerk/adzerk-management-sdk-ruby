# Support for the offline_*_spec.rb files. They stub HTTP with WebMock instead of calling a real network, so they
# need no ADZERK_API_KEY and can run on their own: bundle exec rspec test/offline_creative_spec.rb
#
# WebMock is only switched on around examples tagged :offline, so it never blocks the live specs when both run in
# the same process (e.g. `rake spec`).
#
# To remove WebMock from this gem: delete test/offline_*, delete the webmock line from adzerk.gemspec, and run
# `bundle install`.
require "rspec"
require "json"
require "webmock"
require "adzerk"

RSpec.configure do |config|
  config.include WebMock::API, :offline

  config.before(:each, :offline) do
    WebMock.enable!
    WebMock.disable_net_connect!
  end

  config.after(:each, :offline) do
    WebMock.reset!
    WebMock.disable!
  end
end
