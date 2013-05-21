require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Creative Flight API" do


  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @creative_maps = client.creative_maps
    @advertisers = client.advertisers
    @channels =  client.channels
    @campaigns = client.campaigns
    @sites = client.sites
    @flights  = client.flights
    @priorities = client.priorities
    @zones = client.zones

    advertiser = @advertisers.create(:title => "test")
    @advertiser_id = advertiser[:id].to_s

    channel = @channels.create(:title => 'Test Channel ' + rand(1000000).to_s,
                               :commission => '0.0',
                               :engine => 'CPM',
                               :keywords => 'test',
                               'CPM' => '10.00',
                               :ad_types =>  [1,2,3,4])
    @channel_id = channel[:id].to_s

    priority = @priorities.create(:name => "High Priority Test",
                                  :channel_id => @channel_id,
                                  :weight => 1,
                                  :is_deleted => false)
    @priority_id = priority[:id].to_s

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

     new_flight = {
      :no_end_date => false,
      :priority_id => @priority_id,
      :name => 'Test flight ' + rand(1000000).to_s,
      :start_date => "1/1/2011",
      :endDate => "12/31/2011",
      :noEndDate => false,
      :price => '15.00',
      :option_type => 1,
      :impressions => 10000,
      :is_unlimited => false,
      :is_full_speed => false,
      :keywords => "test, test2",
      :user_agent_keywords => nil,
      :weight_override => nil,
      :campaign_id => @campaign_id,
      :is_active => true,
      :is_deleted => false
    }
    flight = @flights.create(new_flight)
    @flight_id = flight[:id]

    site = @sites.create(:title => 'Test Site ' + rand(1000000).to_s,
                        :url => 'http://www.adzerk.com')
    @site_id = site[:id]

    zone = @zones.create(:name => 'Test Zone ' + rand(10000000).to_s,
                         :site_id => @site_id)
    @zone_id = zone[:id]
  end

  it "should create a creative map" do
    $Title = 'Test creative ' + rand(1000000).to_s
    $ImageName = "test.jpg"
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $AdvertiserId = $advertiserId
    $CampaignId = $campaignId
    $FlightId = $flightId
    $MapId = 0
    $AdTypeId = 18
    $ZoneId = $zoneId
    $SiteId = $siteId
    $SizeOverride = false
    $Iframe = false
    $PublisherAccountId = 372
    $ScriptBody = '<html>'
    $Impressions = 100000
    $Percentage = 50
    $DistributionType = 1
    $IsHTMLJS = true
    $IsActive = true
    $Alt = "test alt"
    $IsDeleted = false
    $IsSync = false

    new_creative = {
      :campaign_id => @campaign_id,
      :flight_id => @flight_id,
      :size_override => false,
      :iframe => false,
      :impressions => 100000,
      :percentage => 50,
      :siteId => @site_id,
      :zoneId => @zone_id,
      :distributionType => 1,
      :isActive => true,
      :isDeleted => false,
      :creative => {
        :title => "Creative Title",
        :url => "http://www.adzerk.com",
        :body => "Test Body",
        :advertiser_id => @advertiser_id,
        :ad_type_id => 18,
        'IsHTMLJS' => true,
        :script_body => "<html></html>",
        :is_active => true,
        :alt => "alt text",
        :is_deleted => false,
        :is_sync => false
      }
    }
    creative_map = @creative_maps.create(new_creative)
    creative_map[:creative][:title].should eq("Creative Title")
    creative_map[:creative][:url].should eq("http://www.adzerk.com")
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:creative][:is_htmljs]
    creative_map[:creative][:script_body].should eq("<html></html>")
    $creative_id_id = creative_map[:creative][:id]
  end

  it "should list all creatives maps for a flight" do
    creative_maps = @creative_maps.list(@flight_id)
    creative_map = creative_maps[:items].last
    $map_id= creative_map[:id]
    creative_map[:creative][:title].should eq("Creative Title")
    creative_map[:creative][:url].should eq("http://www.adzerk.com")
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:creative][:is_htmljs]
    creative_map[:creative][:script_body].should eq("<html></html>")
  end

  it "should get a specific creative map" do
    creative_map = @creative_maps.get($map_id, @flight_id)
    creative_map[:creative][:title].should eq("Creative Title")
    creative_map[:creative][:url].should eq("http://www.adzerk.com")
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:creative][:is_htmljs]
    creative_map[:creative][:script_body].should eq("<html></html>")
 end

  it "should update a specific creative" do
   updated_creative = {
      :id => $map_id,
      :campaign_id => @campaign_id,
      :flight_id => @flight_id,
      :size_override => false,
      :iframe => false,
      :impressions => 200000,
      :percentage => 50,
      :site_id => @site_id,
      :zone_id => @zone_id,
      :is_active => true,
      :is_deleted => false,
      :creative => {
        :id => $creative_id_id
      }
    }
    creative_map = @creative_maps.update(updated_creative)
    creative_map[:impressions].should eq(200000)
  end

  it "should update the scriptBody tag on a nested creative" do
    updated_creative = {
      :id => $map_id,
      :campaign_id => @campaign_id,
      :flight_id => @flight_id,
      :size_override => false,
      :iframe => false,
      :impressions => 200000,
      :percentage => 50,
      :site_id => @site_id,
      :zone_id => @zone_id,
      :is_active => true,
      :is_deleted => false,
      :creative => {
        :id => $creative_id_id,
        :script_body => '<html>New Body</html>',
      }
    }
    creative_map = @creative_maps.update(updated_creative)
    creative_map[:creative][:script_body].should eq('<html>New Body</html>')
  end

  it "should delete the creatives after creating it" do
    response = @creative_maps.delete($map_id, @flight_id)
    response.body.should == "\"This creative map has been deleted\""
  end

  it "should not get a map in a different network" do
    lambda{ @creative_maps.get(123, @flight_id) }.should raise_error "This flight is not part of your network"
  end

  it "should not get a map that's been deleted" do
    lambda{ @creative_maps.get($map_id, @flight_id) }.should raise_error "This creative map has been deleted"
  end

  it "should not update a map that's in a different network" do
    lambda {
      creative_map = @creative_maps.update(
        :id => $map_id,
        :campaign_id => @campaign_id,
        :flight_id => 123,
        :size_override => false,
        :iframe => false,
        :impressions => 200000,
        :percentage => 50,
        :site_id => @site_id,
        :zone_id => @zone_id,
        :is_active => true,
        :is_deleted => false,
        :creative => {
          :id => $creative_id_id
        }
      )
    }.should raise_error "This flight is not part of your network"
  end

  it "should not update a map that's been deleted" do
    lambda {
      creative_map = @creative_maps.update(
        :id => $map_id,
        :campaign_id => @campaign_id,
        :flight_id => @flight_id,
        :size_override => false,
        :iframe => false,
        :impressions => 200000,
        :percentage => 50,
        :site_id => @site_id,
        :zone_id => @zone_id,
        :is_active => true,
        :is_deleted => false,
        :creative => {
          :id => $creative_id_id
        }
      )
    }.should raise_error "This creative map has been deleted"
  end

  it "should fail when creating a map for a campaign in a different network" do
    lambda {
      creative_map = @creative_maps.create(
        :campaign_id => 123,
        :flight_id => @flight_id,
        :size_override => false,
        :iframe => false,
        :impressions => 100000,
        :percentage => 50,
        :siteId => @site_id,
        :zoneId => @zone_id,
        :distributionType => 1,
        :isActive => true,
        :isDeleted => false,
        :creative => {
          :title => "Creative Title",
          :url => "http://www.adzerk.com",
          :body => "Test Body",
          :advertiser_id => @advertiser_id,
          :ad_type_id => 18,
          'IsHTMLJS' => true,
          :script_body => "<html></html>",
          :is_active => true,
          :alt => "alt text",
          :is_deleted => false,
          :is_sync => false
        }
      )
    }.should raise_error "This campaign is not part of your network"
  end

  it "should fail when creating a map for a site in a different network" do
    lambda {
      creative_map = @creative_maps.create(
        :campaign_id => @campaign_id,
        :flight_id => @flight_id,
        :size_override => false,
        :iframe => false,
        :impressions => 100000,
        :percentage => 50,
        :siteId => 123,
        :zoneId => @zone_id,
        :distributionType => 1,
        :isActive => true,
        :isDeleted => false,
        :creative => {
          :title => "Creative Title",
          :url => "http://www.adzerk.com",
          :body => "Test Body",
          :advertiser_id => @advertiser_id,
          :ad_type_id => 18,
          'IsHTMLJS' => true,
          :script_body => "<html></html>",
          :is_active => true,
          :alt => "alt text",
          :is_deleted => false,
          :is_sync => false
        }
      )
    }.should raise_error "This site does not belong to your network"
  end

  it "should fail when creating a map for a zone in a different network" do
    lambda {
      creative_map = @creative_maps.create(
        :campaign_id => @campaign_id,
        :flight_id => @flight_id,
        :size_override => false,
        :iframe => false,
        :impressions => 100000,
        :percentage => 50,
        :siteId => @site_id,
        :zoneId => 11,
        :distributionType => 1,
        :isActive => true,
        :isDeleted => false,
        :creative => {
          :title => "Creative Title",
          :url => "http://www.adzerk.com",
          :body => "Test Body",
          :advertiser_id => @advertiser_id,
          :ad_type_id => 18,
          'IsHTMLJS' => true,
          :script_body => "<html></html>",
          :is_active => true,
          :alt => "alt text",
          :is_deleted => false,
          :is_sync => false
        }
      )
    }.should raise_error "The site associated with that zone does not belong to your network"
  end
end
