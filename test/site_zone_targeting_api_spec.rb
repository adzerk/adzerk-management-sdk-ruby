require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "SiteZoneTargeting API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @flights = client.flights
    @advertisers = client.advertisers
    @channels = client.channels
    @campaigns = client.campaigns
    @priorities = client.priorities
    @sitezonetargeting = client.sitezonetargetings
    @sites = client.sites
    @zones = client.zones
    advertiser = @advertisers.create(:title => "test")
    $advertiserId = advertiser[:id].to_s

    channel = @channels.create(:title => 'Test Channel ' + rand(1000000).to_s,
                               :commission => '0.0',
                               :engine => 'CPM',
                               :keywords => 'test',
                               'CPM' => '10.00',
                               :ad_types =>  [1,2,3,4])
    $channel_id = channel[:id].to_s

    priority = @priorities.create(:name => "High Priority Test",
                                  :channel_id => $channel_id,
                                  :weight => 1,
                                  :is_deleted => false)
    $priority_id = priority[:id].to_s

    campaign = @campaigns.
      create(:name => 'Test campaign ' + rand(1000000).to_s,
             :start_date => "1/1/2011",
             :end_date => "12/31/2011",
             :is_active => false,
             :price => '10.00',
             :advertiser_id => $advertiserId,
             :flights => [],
             :is_deleted => false)
    $campaign_id = campaign[:id]

    new_flight = {
      :priority_id => $priority_id,
      :name => 'Test flight ' + rand(1000000).to_s,
      :start_date => "1/1/2011",
      :end_date => "12/31/2011",
      :no_end_date => false,
      :price => '15.00',
      :option_type => 1,
      :impressions => 10000,
      :is_unlimited => false,
      :is_full_speed => false,
      :keywords => "test, test2",
      :user_agent_keywords => nil,
      :weight_override => nil,
      :campaign_id => $campaign_id,
      :is_active => true,
      :is_deleted => false,
      :goal_type => 1
    }
    flight = @flights.create(new_flight)
    $flight_id = flight[:id].to_s

    site_title = 'Test Site ' + rand(1000000).to_s
    site = @sites.create(:title => site_title, :url => 'http://www.adzerk.com')
    $site_id = site[:id].to_s

    zone_name = 'Test Zone ' + rand(1000000).to_s
    zone = @zones.create(:name => zone_name,
                         :site_id => $site_id,
                         :is_deleted => false)
    $zone_id = zone[:id].to_s
  end

  after(:all) do
    @flights.delete($flight_id)
    @campaigns.delete($campaign_id)
    @advertisers.delete($advertiserId)
    @zones.delete($zone_id)
    @sites.delete($site_id)
    @priorities.delete($priority_id)
    @channels.delete($channel_id)
  end

  it "should create a sitezone targeting" do
    $sitezone_SiteId = $site_id;
    $sitezone_ZoneId = $zone_id;
    $sitezone_IsExclude = true;

    new_sitezone = {
      :site_id => $sitezone_SiteId,
      :zone_id => $sitezone_ZoneId,
      :is_exclude => true,
    }

    sitezone = @sitezonetargeting.create($flight_id, new_sitezone)
    expect(sitezone[:site_id]).to eq($sitezone_SiteId.to_i)
    expect(sitezone[:zone_id]).to eq($sitezone_ZoneId.to_i)
    expect(sitezone[:is_exclude]).to eq(true)
    $sitezone_id = sitezone[:id]

  end

  it "should retrieve a sitezone targeting" do
    sitezone = @sitezonetargeting.get($flight_id,$sitezone_id)
    expect(sitezone[:site_id]).to eq($sitezone_SiteId.to_i)
    expect(sitezone[:zone_id]).to eq($sitezone_ZoneId.to_i)
    expect(sitezone[:is_exclude]).to eq(true)
  end

  it "should update a sitezone targeting" do
    data = {
      :site_id => $sitezone_SiteId,
      :zone_id => $sitezone_ZoneId,
      :is_exclude => false,
    }
    sitezone = @sitezonetargeting.update($flight_id,$sitezone_id,data)
    expect(sitezone[:is_exclude]).to eq(false)
  end

  it "should delete a sitezone targeting" do
    sitezone = @sitezonetargeting.delete($flight_id,$sitezone_id)
    expect(sitezone.body).to include("Successfully deleted")
  end

  it "should error when deleting a sitezone targeting that does not exist" do
    expect {
      @sitezonetargeting.delete($flight_id,1)
    }.to raise_error "This PassSiteMap does not exist in your network."
  end

  it "should check if a flight is not a part of your network" do
    non_network_flight = 123;
    expect{ @sitezonetargeting.delete(non_network_flight,1) }.to raise_error("This Flight does not belong to your network.")
    expect{ @sitezonetargeting.get(non_network_flight,1) }.to raise_error("This Flight does not belong to your network.")
    expect{ @sitezonetargeting.update(non_network_flight,1,{}) }.to raise_error("Flight is not a part of your network")
  end

end
