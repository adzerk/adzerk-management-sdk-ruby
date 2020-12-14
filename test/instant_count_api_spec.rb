require 'pp'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Instant Count API" do
  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @instant_counts = client.instant_counts
  end

  it "should fetch bulk instant counts" do
    advertiser_id = 1065290
    campaign_id = 1582611

    counts = @instant_counts.bulk({
      :advertisers => [advertiser_id],
      :campaigns => [campaign_id]
    })

    expect(counts).to have_key(:advertisers)
    expect(counts[:advertisers]).to have_key(advertiser_id.to_s.to_sym)

    expect(counts).to have_key(:campaigns)
    expect(counts[:campaigns]).to have_key(campaign_id.to_s.to_sym)
  end
end