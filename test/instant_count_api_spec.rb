require 'pp'
require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Instant Count API" do
  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @instant_counts = client.instant_counts
    @advertisers = client.advertisers
    @campaigns = client.campaigns

    advertiser = @advertisers.create(:title => "test")
    @advertiser_id = advertiser[:id]

    campaign = @campaigns.
      create(:name => 'Test campaign ' + rand(1000000).to_s,
             :start_date => "1/1/2011",
             :end_date => "12/31/2011",
             :is_active => false,
             :price => '10.00',
             :advertiser_id => @advertiser_id,
             :flights => [],
             :is_deleted => false)
    @campaign_id = campaign[:id]
  end

  after(:all) do
    @campaigns.delete(@campaign_id)
    @advertisers.delete(@advertiser_id)
  end

  it "should fetch bulk instant counts" do
    advertiser_id = @advertiser_id
    campaign_id = @campaign_id

    counts = @instant_counts.bulk({
      :advertisers => [advertiser_id],
      :campaigns => [campaign_id]
    })
  
    expect(counts).to have_key(:advertisers)
    expect(counts[:advertisers].keys).to include(advertiser_id.to_s)

    expect(counts).to have_key(:campaigns)
    expect(counts[:campaigns].keys).to include(campaign_id.to_s)
  end

  it "should get network instant counts" do
    data = {
      start: "2022-08-04",
      end: "2022-08-20"
    }
    count = @instant_counts.network_counts(data)
    expect(count.length).to be > 0
  end
end