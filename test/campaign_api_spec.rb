require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Campaign API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @campaigns = client.campaigns
    @advertisers = client.advertisers
    @channels = client.channels
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
  end



  it "should create a new campaign with no flights" do
    $campaign_name = 'Test campaign ' + rand(1000000).to_s
    $campaign_start_date = "1/1/2011"
    $campaign_end_date = "12/31/2011"
    $campaign_is_active = false
    $campaign_price = '10.00'
    $campaign_advertiser_id = $advertiserId.to_i
    $campaign_flights = []

    campaign = @campaigns.create(:name => $campaign_name,
                                 :start_date => $campaign_start_date,
                                 :end_date => $campaign_end_date,
                                 :is_active => $campaign_is_active,
                                 :price => $campaign_price,
                                 :advertiser_id => $campaign_advertiser_id,
                                 :flights => $campaign_flights,
                                 :is_deleted => false)

    $campaign_id = campaign[:id].to_s
    $campaign_name.should == campaign[:name]
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    $campaign_is_active.should == campaign[:is_active]
    $campaign_price.to_f.should == campaign[:price]
    $campaign_advertiser_id.should == campaign[:advertiser_id]
    campaign[:is_deleted].should == false
    campaign[:flights].should eq([])
  end

  it "should create a new campaign with one flight" do
    @campaign_flights_1 = [{
      :start_date => "1/1/2011",
      :end_date => "12/31/2011",
      :no_end_date => false,
      :price => "5.00",
      :keywords => "test, test2",
      :name => "Test",
      :priority_id => $priority_id,
      :impressions => 10000,
      :is_deleted => false
    }]
    new1_campaign = {
      :name => $campaign_name,
      :start_date => $campaign_start_date,
      :end_date => $campaign_end_date,
      :is_active => $campaign_is_active,
      :price => $campaign_price,
      :advertiser_id => $campaign_advertiser_id,
      :is_deleted => false,
      :flights => @campaign_flights_1
    }
    campaign = @campaigns.create(new1_campaign)
    $campaign_id_1 = campaign[:id].to_s
    $campaign_name.should == campaign[:name]
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    $campaign_is_active.should == campaign[:is_active]
    campaign[:is_deleted].should == false
    $campaign_price.to_f.should == campaign[:price]
    $campaign_advertiser_id.should == campaign[:advertiser_id]
    # $campaign_Flights1.to_json.should == JSON.parse(response.body)["Flights"]
  end


  it "should list a specific campaign" do
    campaign = @campaigns.get($campaign_id_1)
    campaign[:id].should eq($campaign_id_1.to_i)
    campaign[:flights].should_not be_empty
    campaign[:name].should eq($campaign_name)
  end

  it "should update a campaign" do
    $campaign_name = 'Test campaign ' + rand(1000000).to_s
    $campaign_start_date = "1/1/2011"
    $campaign_end_date = "12/31/2011"
    $campaign_is_active = false
    $campaign_price = '12.00'
    $campaign_flights = []

    campaign_to_update = {
      :id => $campaign_id,
      :name => $campaign_name,
      :start_date => $campaign_start_date,
      :end_date => $campaign_end_date,
      :is_active => $campaign_is_active,
      :price => $campaign_price,
      :advertiser_id => $campaign_advertiser_id,
      :flights => $campaign_flights,
      :is_deleted => false
    }

    campaign = @campaigns.update(campaign_to_update)
    campaign[:name].should eq($campaign_name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    campaign[:is_active].should eq($campaign_is_active)
    campaign[:price].should eq($campaign_price.to_f)
    campaign[:advertiser_id].should eq($campaign_advertiser_id)
    campaign[:is_deleted].should eq(false)
    campaign[:flights].should eq($campaign_flights)
  end

  it "should list all campaigns" do
    campaigns = @campaigns.list
    campaigns.length.should > 0
  end

  it "should delete a new campaign" do
    response = @campaigns.delete($campaign_id)
    response.body.should == 'OK'
  end

end
