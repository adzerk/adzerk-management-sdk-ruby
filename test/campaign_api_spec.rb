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

  after(:all) do
    @campaigns.delete($campaign_id_1)
    @advertisers.delete($campaign_advertiser_id)
    @priorities.delete($priority_id)
    @channels.delete($channel_id)
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
    expect($campaign_name).to eq(campaign[:name])
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    expect($campaign_is_active).to eq(campaign[:is_active])
    expect($campaign_price.to_f).to eq(campaign[:price])
    expect($campaign_advertiser_id).to eq(campaign[:advertiser_id])
    expect(campaign[:is_deleted]).to eq(false)
    expect(campaign[:flights]).to eq([])
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
      :is_deleted => false,
      :goal_type => 1
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
    expect($campaign_name).to eq(campaign[:name])
    expect($campaign_is_active).to eq(campaign[:is_active])
    expect(campaign[:is_deleted]).to eq(false)
    expect($campaign_price.to_f).to eq(campaign[:price])
    expect($campaign_advertiser_id).to eq(campaign[:advertiser_id])
    expect(campaign[:flights].first[:id]).not_to eq(nil)
  end


  it "should list a specific campaign" do
    campaign = @campaigns.get($campaign_id_1)
    expect(campaign[:id]).to eq($campaign_id_1.to_i)
    expect(campaign[:flights]).not_to be_empty
    expect(campaign[:name]).to eq($campaign_name)
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
    expect(campaign[:name]).to eq($campaign_name)
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    expect(campaign[:is_active]).to eq($campaign_is_active)
    expect(campaign[:price]).to eq($campaign_price.to_f)
    expect(campaign[:advertiser_id]).to eq($campaign_advertiser_id)
    expect(campaign[:is_deleted]).to eq(false)
    expect(campaign[:flights]).to eq($campaign_flights)
  end

  it "should list all campaigns" do
    campaigns = @campaigns.list
    expect(campaigns.length).to be > 0
  end


  it "should get campaign instant counts" do
    data = {
      days: 5
    }
    count = @campaigns.instant_counts($campaign_id, data)
    expect(count.length).to be > 0
  end

  it "should not create/update a campaign with a advertiserId that doesn't belong to it" do
    new_campaign = {
      :name => 'Test campaign ' + rand(1000000).to_s,
      :start_date => "1/1/2011",
      :end_date => "12/31/2011",
      :is_active => false,
      :price => '10.00',
      :advertiser_id => '123',
      :flights => [],
      :is_deleted => false
    }

    expect{ @campaigns.create(new_campaign) }.to raise_error("This advertiser is not part of your network")
  end

  it "should not update a campaign with a new advertiserId" do
    updated_campaign = {
      :id => $campaign_id,
      :name => 'Test campaign ' + rand(1000000).to_s,
      :start_date => "1/1/2011",
      :end_date => "12/31/2011",
      :is_active => false,
      :price => '10.00',
      :advertiser_id => '123',
      :flights => [],
      :is_deleted => false
    }

    expect{ @campaigns.update(updated_campaign) }.to raise_error("This campaign belongs to advertiser #{$advertiserId}; a different advertiser cannot be specified.")
  end

  it "should not retrieve a campaign with a advertiserId that doesn't belong to it" do
    expect { @campaigns.get('123') }.to raise_error("Campaign not found.")
  end

    it "should delete a new campaign" do
    response = @campaigns.delete($campaign_id)
    expect(response.body).to eq('"Successfully deleted."')
  end

  it "should not update a deleted campaign" do
    campaign_to_update = {
      :id => $campaign_id,
      :name => "test"
    }

    expect { @campaigns.update(campaign_to_update) }.to raise_error("This campaign has been deleted")
  end

end
