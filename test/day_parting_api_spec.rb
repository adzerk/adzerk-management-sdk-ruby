require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "DayParting API" do
    before(:all) do
        client = Adzerk::Client.new(API_KEY)
        @day_partings = client.day_parts
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

    it "should create a day part entity" do
        data = {
            :start_time => '09:30:00',
            :end_time => '17:00:00',
            :week_days => ['MO','TU']
        }

        response = @day_partings.create($flight_id, data)
        expect(response[:timepart_id]).to_not eq(nil)
        $timepart_id = response[:timepart_id].to_s
    end

    it "should get a day parting entity associated with a flight" do
        response = @day_partings.get($flight_id, $timepart_id)
        expect(response[:id].to_s).to eq($timepart_id)
        expect(response[:flight_id].to_s).to eq($flight_id)
        expect(response[:start_time]).to_not eq(nil)
        expect(response[:end_time]).to_not eq(nil)
        expect(response[:week_days]).to_not eq(nil)
    end

    it "should list all the day part entities in a flight" do
        response = @day_partings.list($flight_id)
        expect(response[:items].length).to be > 0
    end

    it "should delete a day part entity associated with a flight" do
        response = @day_partings.delete($flight_id, $timepart_id)
        expect(response.code).to eq('204')
    end
end