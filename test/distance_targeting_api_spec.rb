require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DistanceTargeting API" do
    before(:all) do
        client = Adzerk::Client.new(API_KEY)
        @distance_targeting = client.distance_targetings
        @flights = client.flights
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
    end

    after(:all) do
        @flights.delete($flight_id)
        @campaigns.delete($campaign_id)
        @advertisers.delete($advertiserId)
        @priorities.delete($priority_id)
        @channels.delete($channel_id)
    end

    it "should create a Distance Targeting Geometry object with a street address" do
        distance = 42
        address = "1600 Pennsylvania Avenue NW, Washington DC 20500"
        data = {
            :distance => distance,
            :street_address => address
        }

        response = @distance_targeting.create($flight_id, data)
        expect(response[:flight_id].to_s).to eq($flight_id)
        expect(response[:distance]).to eq(distance)
        expect(response[:street_address]).to eq(address)
        $geometry_id = response[:id]
    end

    it "should upload a batch of Distance Targeting Geometries" do
        data = {
            :replace_existing => false,
            :geometries => [
                {
                    :latitude => -89.05,
                    :longitude => 57.1,
                    :distance => 5
                },
                {
                    :latitude => 14,
                    :longitude => 57.1,
                    :distance => 5
                }
            ]
        }

        response = @distance_targeting.batch_upload($flight_id, data)
        expect(response[:inserted_geometries]).to_not eq(nil)
    end

    it "should update a Distance Targeting Geometry" do
        new_distance = 43
        new_address = "701 N 1st Ave, Minneapolis MN 55403"
        data = {
            :distance => new_distance,
            :street_address => new_address
        }

        response = @distance_targeting.update($flight_id, $geometry_id, data)
        expect(response[:flight_id].to_s).to eq($flight_id)
        expect(response[:id]).to eq($geometry_id)
        expect(response[:distance]).to eq(new_distance)
        expect(response[:street_address]).to eq(new_address)
    end

    it "should get a specific Distance Targeting Geometry" do
        response = @distance_targeting.get($flight_id, $geometry_id)
        expect(response[:flight_id].to_s).to eq($flight_id)
        expect(response[:id]).to eq($geometry_id)
    end

    it "should list Distance Targeting Geometry objects associated with a flight" do
        response = @distance_targeting.list($flight_id)
        expect(response.length).to be > 0
    end

    it "should delete a specific Distance Targeting Geometry" do
        response = @distance_targeting.delete($flight_id, $geometry_id)
        expect(response.code).to eq('204')
    end
end