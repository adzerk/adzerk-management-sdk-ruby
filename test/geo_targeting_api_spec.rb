require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "GeoTargeting API" do


  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    client = Adzerk::Client.new(API_KEY)
    @flights= client.flights
    @advertisers = client.advertisers
    @channels = client.channels
    @campaigns = client.campaigns
    @priorities = client.priorities
    @geotargetings = client.geotargetings
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
      :no_end_date => false,
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

  end

  it "should create a geotargeting" do
    $geo_CountryCode = "US";
    $geo_Region = "NC";
    $geo_MetroCode = 560;
    $geo_IsExclude = true;

    new_geo = {
      :country_code => $geo_CountryCode,
      :region => $geo_Region,
      :metro_code => $geo_MetroCode,
      :is_exclude => true,
    }
 
    geo = @geotargetings.create($flight_id, new_geo)
    expect(geo[:country_code]).to eq($geo_CountryCode)
    expect(geo[:region]).to eq($geo_Region)
    expect(geo[:metro_code]).to eq($geo_MetroCode)
    expect(geo[:is_exclude]).to eq(true)
    $geo_id = geo[:location_id]

  end

  it "should retrieve a geotargeting" do
    geo = @geotargetings.get($flight_id,$geo_id)
  end

  it "should update a geotargeting" do
    data = {
      :country_code => $geo_CountryCode,
      :region => $geo_Region,
      :metro_code => 517,
      :is_exclude => true,
    }
    geo = @geotargetings.update($flight_id,$geo_id,data)
    expect(geo[:metro_code]).to eq(517)
  end

  it "should delete a geotargeting" do
    geo = @geotargetings.delete($flight_id,$geo_id)
  end

  it "should error when deleting a geotargeting that does not exist" do
    expect{ geo = @geotargetings.delete($flight_id,1) }.to raise_error
  end

  it "should check if a flight is not a part of your network" do
    non_network_flight = 123;
    expect{ @geotargetings.delete(non_network_flight,1) }.to raise_error("Flight is not a part of your network")
    expect{ @geotargetings.get(non_network_flight,1) }.to raise_error("Flight is not a part of your network")
    expect{ @geotargetings.update(non_network_flight,1,{}) }.to raise_error("Flight is not a part of your network")
  end

end