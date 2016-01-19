require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Flight API" do

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

  end

  it "should create a flight" do
    $flight_Name = 'Test flight ' + rand(1000000).to_s
    $flight_StartDate = "1/1/2011"
    $flight_EndDate = "12/31/2011"
    $flight_NoEndDate = false
    $flight_Price = '15.00'
    $flight_OptionType = 1
    $flight_Impressions = 10000
    $flight_IsUnlimited = false
    $flight_IsFullSpeed = false
    $flight_Keywords = "test, test2"
    $flight_UserAgentKeywords = nil
    $flight_WeightOverride = nil
    $flight_CampaignId = $campaign_id
    $flight_IsActive = true
    $flight_IsDeleted = false
    $flight_GoalType = 1

    new_flight = {
      :no_end_date => false,
      :priority_id => $priority_id,
      :name => $flight_Name,
      :start_date => $flight_StartDate,
      :end_date => $flight_EndDate,
      :no_end_date => $flight_NoEndDate,
      :price => $flight_Price,
      :option_type => $flight_OptionType,
      :impressions => $flight_Impressions,
      :is_unlimited => $flight_IsUnlimited,
      :is_full_speed => $flight_IsFullSpeed,
      :keywords => $flight_Keywords,
      :user_agent_keywords => $flight_UserAgentKeywords,
      :weight_override => $flight_WeightOverride,
      :campaign_id => $flight_CampaignId,
      :is_active => $flight_IsActive,
      :is_deleted => $flight_IsDeleted,
      :goal_type => $flight_GoalType,
      :is_companion => true
    }
    flight = @flights.create(new_flight)
    $flight_id = flight[:id].to_s
    expect(flight[:no_end_date]).to be false
    expect(flight[:priority_id]).to eq($priority_id.to_i)
    expect(flight[:name]).to eq($flight_Name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    expect(flight[:price]).to eq(15.0)
    expect(flight[:option_type]).to eq($flight_OptionType)
    expect(flight[:impressions]).to eq($flight_Impressions)
    expect(flight[:is_unlimited]).to eq($flight_IsUnlimited)
    expect(flight[:is_full_speed]).to eq($flight_IsFullSpeed)
    expect(flight[:keywords]).to eq($flight_Keywords)
    expect(flight[:user_agent_keywords]).to eq($flight_UserAgentKeywords)
    expect(flight[:weight_override]).to eq($flight_WeightOverride)
    expect(flight[:campaign_id]).to eq($flight_CampaignId)
    expect(flight[:is_active]).to eq($flight_IsActive)
    expect(flight[:is_deleted]).to eq($flight_IsDeleted)
    expect(flight[:goal_type]).to eq($flight_GoalType)
    expect(flight[:is_companion]).to be true
  end

  it "should fail to create a flight without a goal type" do
    flight_without_goal_type = {
      :no_end_date => false,
      :priority_id => $priority_id,
      :name => $flight_Name,
      :start_date => $flight_StartDate,
      :end_date => $flight_EndDate,
      :no_end_date => $flight_NoEndDate,
      :price => $flight_Price,
      :option_type => $flight_OptionType,
      :impressions => $flight_Impressions,
      :is_unlimited => $flight_IsUnlimited,
      :is_full_speed => $flight_IsFullSpeed,
      :keywords => $flight_Keywords,
      :user_agent_keywords => $flight_UserAgentKeywords,
      :weight_override => $flight_WeightOverride,
      :campaign_id => $flight_CampaignId,
      :is_active => $flight_IsActive,
      :is_deleted => $flight_IsDeleted
    }

    expect { @flights.create flight_without_goal_type }.to raise_error
  end

  it "should list a specific flight" do
    flight = @flights.get($flight_id)
    expect(flight[:priority_id]).to eq($priority_id.to_i)
    expect(flight[:name]).to eq($flight_Name)
    expect(flight[:price]).to eq(15.0)
    expect(flight[:option_type]).to eq($flight_OptionType)
    expect(flight[:impressions]).to eq($flight_Impressions)
    expect(flight[:is_unlimited]).to eq($flight_IsUnlimited)
    expect(flight[:is_full_speed]).to eq($flight_IsFullSpeed)
    expect(flight[:keywords]).to eq($flight_Keywords)
    expect(flight[:user_agent_keywords]).to eq($flight_UserAgentKeywords)
    expect(flight[:weight_override]).to eq($flight_WeightOverride)
    expect(flight[:campaign_id]).to eq($flight_CampaignId)
    expect(flight[:is_active]).to eq($flight_IsActive)
    expect(flight[:is_deleted]).to eq($flight_IsDeleted)
    expect(flight[:goal_type]).to eq($flight_GoalType)
    expect(flight[:is_companion]).to be true
  end

  it "should update a flight" do
    flight = @flights.update(:id => $flight_id,
                             :campaign_id => $flight_CampaignId,
                             :name => "New Flight Name",
                             :priority_id => $priority_id,
                             :start_date => $flight_StartDate,
                             :goal_type => $flight_GoalType,
                             :impressions => $flight_Impressions,
                             :is_companion => false)
    expect(flight[:name]).to eq("New Flight Name")
    expect(flight[:is_companion]).to be false
  end

  it "should list all flights" do
    flights = @flights.list
    expect(flights.length).to be > 0
  end

  it "should delete a new flight" do
    response = @flights.delete($flight_id)
    expect(response.body).to eq('"Successfully deleted"')
  end

  it "should create a flight with geotargeting" do
    geo = [{
      'CountryCode' => 'US',
      'Region' => 'NC',
      'MetroCode' => '560'
    }]

    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
      'Name' => $flight_Name,
      'StartDate' => $flight_StartDate,
      'EndDate' => $flight_EndDate,
      'NoEndDate' => $flight_NoEndDate,
      'Price' => $flight_Price,
      'OptionType' => $flight_OptionType,
      'Impressions' => $flight_Impressions,
      'IsUnlimited' => $flight_IsUnlimited,
      'IsFullSpeed' => $flight_IsFullSpeed,
      'Keywords' => $flight_Keywords,
      'UserAgentKeywords' => $flight_UserAgentKeywords,
      'WeightOverride' => $flight_WeightOverride,
      'CampaignId' => $flight_CampaignId,
      'IsActive' => $flight_IsActive,
      'IsDeleted' => $flight_IsDeleted,
      'GeoTargeting' => geo,
      'GoalType' => $flight_GoalType
    }
    flight = @flights.create(new_flight)
    $flight_id = flight[:id].to_s
    expect(flight[:no_end_date]).to eq(false)
    expect(flight[:priority_id]).to eq($priority_id.to_i)
    expect(flight[:name]).to eq($flight_Name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    expect(flight[:price]).to eq(15.0)
    expect(flight[:option_type]).to eq($flight_OptionType)
    expect(flight[:impressions]).to eq($flight_Impressions)
    expect(flight[:is_unlimited]).to eq($flight_IsUnlimited)
    expect(flight[:is_full_speed]).to eq($flight_IsFullSpeed)
    expect(flight[:keywords]).to eq($flight_Keywords)
    expect(flight[:user_agent_keywords]).to eq($flight_UserAgentKeywords)
    expect(flight[:weight_override]).to eq($flight_WeightOverride)
    expect(flight[:campaign_id]).to eq($flight_CampaignId)
    expect(flight[:is_active]).to eq($flight_IsActive)
    expect(flight[:is_deleted]).to eq($flight_IsDeleted)
    geotargeting = flight[:geo_targeting].first
    expect(geotargeting[:country_code]).to eq("US")
    expect(geotargeting[:region]).to eq("NC")
    expect(geotargeting[:metro_code]).to eq(560)
    expect(flight[:goal_type]).to eq($flight_GoalType)
  end

  it "should not create a flight for a campaign in a different network" do
    expect{
      flight = @flights.create(
        :no_end_date => false,
        :priority_id => $priority_id,
        :name => $flight_Name,
        :start_date => $flight_StartDate,
        :end_date => $flight_EndDate,
        :no_end_date => $flight_NoEndDate,
        :price => $flight_Price,
        :option_type => $flight_OptionType,
        :impressions => $flight_Impressions,
        :is_unlimited => $flight_IsUnlimited,
        :is_full_speed => $flight_IsFullSpeed,
        :keywords => $flight_Keywords,
        :user_agent_keywords => $flight_UserAgentKeywords,
        :weight_override => $flight_WeightOverride,
        :campaign_id => 123,
        :is_active => $flight_IsActive,
        :is_deleted => $flight_IsDeleted,
        :goal_type => $flight_GoalType
      )
    }.to raise_error "This campaign is not part of your network"
  end
end
