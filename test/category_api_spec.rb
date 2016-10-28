require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Category API" do


  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @flights= client.flights
    @advertisers = client.advertisers
    @channels = client.channels
    @campaigns = client.campaigns
    @priorities = client.priorities
    @category = client.categories
    # @sites = client.sites
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

    $category_name = 'test category'
    $new_category = {
      :name => $category_name
    }

  end

  after(:all) do
    @flights.delete($flight_id)
    @campaigns.delete($campaign_id)
    @advertisers.delete($advertiserId)
    @priorities.delete($priority_id)
    @channels.delete($channel_id)
  end

  it "should add a category to a flight" do
    cat = @category.create($flight_id, $new_category)
    $category_id = cat[:id]
    expect(cat[:name]).to eq($category_name)
  end

  it "should list categories for a given flight" do
    cat = @category.list($flight_id)[:items].first
    expect(cat[:name]).to eq($category_name)
    expect(cat[:id]).to eq($category_id)
  end

  it "should list categories for the current network" do
    cats = @category.listAll()[:items].select { |x| x[:name] == $category_name }
    expect(cats.count).to eq(1)
  end

  it "should delete a category from a flight" do
    response = @category.delete($flight_id, $category_id)
    expect(response.body).to eq('"Successfully deleted"')
  end

  it "should error when the flight or category id does not exist or does not belong to the network" do
    bad_id = 0

    expect {
      @category.create(bad_id, $new_category)
    }.to raise_error "Flight is not a part of your network"

    expect {
      @category.list(bad_id)
    }.to raise_error "Flight is not a part of your network"

    expect {
      @category.delete(bad_id,$category_id)
    }.to raise_error "Flight is not a part of your network"

    expect {
      @category.delete($flight_id,bad_id)
    }.to raise_error "Category is not part of your network"
  end

end
