require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'awesome_print'

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
    @advertiser_id = advertiser[:id]

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

    $ImageName = "test.jpg"
    
    $SizeOverride = false
    $Iframe = false
    $Impressions = 10000
    $Percentage = 50
    $DistributionType = 1
    $IsMapActive = true
    $IsMapDeleted = false
    
    $Title = 'Test creative ' + rand(1000000).to_s
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $AdTypeId = 18
    $IsHTMLJS = true
    $ScriptBody = '<html></html>'
    $IsCreativeActive = true
    $IsCreativeDeleted = false
    $Alt = "test alt"
    $IsSync = false

    $PublisherAccountId = 372
    
    new_creative = {
      :campaign_id => @campaign_id,
      :flight_id => @flight_id,
      :size_override => $SizeOverride,
      :iframe => $Iframe,
      :impressions => $Impressions,
      :percentage => $Percentage,
      :siteId => @site_id,
      :zoneId => @zone_id,
      :distributionType => $DistributionType,
      :isActive => $IsMapActive,
      :isDeleted => $IsMapDeleted,
      :creative => {
        :title => $Title,
        :url => $Url,
        :body => $Body,
        :advertiser_id => @advertiser_id,
        :ad_type_id => $AdTypeId,
        'IsHTMLJS' => $IsHTMLJS,
        :script_body => $ScriptBody,
        :is_active => $IsCreativeActive,
        :is_deleted => $IsCreativeDeleted,
        :alt => $Alt,
        :is_sync => $IsSync
      }
    }
    creative_map = @creative_maps.create(new_creative)

    # size_override and iframe are left out because they are optional
    # and always return null
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    #unless distribution type is Fixed (3) this value is ignored
    creative_map[:impressions].should eq($Impressions)
    creative_map[:percentage].should eq($Percentage)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:distribution_type].should eq($DistributionType)
    creative_map[:is_active].should eq($IsMapActive)
    creative_map[:is_deleted].should eq($IsMapDeleted)

    creative_map[:creative][:title].should eq($Title)
    creative_map[:creative][:url].should eq($Url)
    creative_map[:creative][:body].should eq($Body)
    creative_map[:creative][:advertiser_id].should eq(@advertiser_id)
    creative_map[:creative][:ad_type_id].should eq($AdTypeId)
    creative_map[:creative][:is_htmljs].should eq($IsHTMLJS)
    creative_map[:creative][:script_body].should eq($ScriptBody)
    creative_map[:creative][:is_active].should eq($IsCreativeActive)
    creative_map[:creative][:is_deleted].should eq($IsCreativeDeleted)
    creative_map[:creative][:alt].should eq($Alt)
    creative_map[:creative][:is_sync].should eq($IsSync)

    $creative_id = creative_map[:creative][:id]
  end

  it "should list all creatives maps for a flight" do
    creative_maps = @creative_maps.list(@flight_id)
    creative_map = creative_maps[:items].last
    $map_id= creative_map[:id]

    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:impressions].should eq($Impressions)
    creative_map[:percentage].should eq($Percentage)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:distribution_type].should eq($DistributionType)
    creative_map[:is_active].should eq($IsMapActive)
    creative_map[:is_deleted].should eq($IsMapDeleted)

    creative_map[:creative][:title].should eq($Title)
    creative_map[:creative][:url].should eq($Url)
    creative_map[:creative][:body].should eq($Body)
    creative_map[:creative][:advertiser_id].should eq(@advertiser_id)
    creative_map[:creative][:ad_type_id].should eq($AdTypeId)
    creative_map[:creative][:is_htmljs].should eq($IsHTMLJS)
    creative_map[:creative][:script_body].should eq($ScriptBody)
    creative_map[:creative][:is_active].should eq($IsCreativeActive)
    creative_map[:creative][:is_deleted].should eq($IsCreativeDeleted)
    creative_map[:creative][:alt].should eq($Alt)
    creative_map[:creative][:is_sync].should eq($IsSync)
  end

  it "should get a specific creative map" do
    creative_map = @creative_maps.get($map_id, @flight_id)
    
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:impressions].should eq($Impressions)
    creative_map[:percentage].should eq($Percentage)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:distribution_type].should eq($DistributionType)
    creative_map[:is_active].should eq($IsMapActive)
    creative_map[:is_deleted].should eq($IsMapDeleted)

    creative_map[:creative][:title].should eq($Title)
    creative_map[:creative][:url].should eq($Url)
    creative_map[:creative][:body].should eq($Body)
    creative_map[:creative][:advertiser_id].should eq(@advertiser_id)
    creative_map[:creative][:ad_type_id].should eq($AdTypeId)
    creative_map[:creative][:is_htmljs].should eq($IsHTMLJS)
    creative_map[:creative][:script_body].should eq($ScriptBody)
    creative_map[:creative][:is_active].should eq($IsCreativeActive)
    creative_map[:creative][:is_deleted].should eq($IsCreativeDeleted)
    creative_map[:creative][:alt].should eq($Alt)
    creative_map[:creative][:is_sync].should eq($IsSync)
 end

  it "should update a specific creative map" do
    
    new_impressions = 1234
    new_percentage = 51
    new_is_active = false

    updated_creative = {
      :id => $map_id,
      :campaign_id => @campaign_id,
      :flight_id => @flight_id,
      :size_override => $SizeOverride,
      :iframe => $iframe,
      :impressions => new_impressions,
      :percentage => new_percentage,
      :site_id => @site_id,
      :zone_id => @zone_id,
      :distribution_type => $DistributionType,
      :is_active => new_is_active,
      :is_deleted => false,
      :creative => {
        :id => $creative_id
      }
    }
    creative_map = @creative_maps.update(updated_creative)
    
    #test new values
    creative_map[:percentage].should eq(new_percentage)
    creative_map[:impressions].should eq(new_impressions)
    creative_map[:is_active].should eq(new_is_active)

    #make sure old values are unchanged
    creative_map[:campaign_id].should eq(@campaign_id)
    creative_map[:flight_id].should eq(@flight_id)
    creative_map[:site_id].should eq(@site_id)
    creative_map[:zone_id].should eq(@zone_id)
    creative_map[:distribution_type].should eq($DistributionType)
    creative_map[:is_deleted].should eq($IsMapDeleted)

    creative_map[:creative][:title].should eq($Title)
    creative_map[:creative][:url].should eq($Url)
    creative_map[:creative][:body].should eq($Body)
    creative_map[:creative][:advertiser_id].should eq(@advertiser_id)
    creative_map[:creative][:ad_type_id].should eq($AdTypeId)
    creative_map[:creative][:is_htmljs].should eq($IsHTMLJS)
    creative_map[:creative][:script_body].should eq($ScriptBody)
    creative_map[:creative][:is_active].should eq($IsCreativeActive)
    creative_map[:creative][:is_deleted].should eq($IsCreativeDeleted)
    creative_map[:creative][:alt].should eq($Alt)
    creative_map[:creative][:is_sync].should eq($IsSync)
  end

  it "should update the nested creative" do

    new_title = "new title"
    new_url = "http://newurl.com"
    new_body = "new_body"
    new_ad_type_id = 5
    new_script_body = "<html>new body</html>"
    new_is_active = false
    new_alt = "new alt text"
    new_is_sync = true
    new_image_name = "new image name"

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
        :id => $creative_id,
        :title => new_title,
        :url => new_url,
        :body => new_body,
        :advertiser_id => @advertiser_id,
        :ad_type_id => new_ad_type_id,
        'IsHTMLJS' => true,
        :script_body => new_script_body,
        :is_active => new_is_active,
        :alt => new_alt,
        :is_deleted => false,
        :is_sync => new_is_sync,
        :image_name => new_image_name
      }
    }
    creative_map = @creative_maps.update(updated_creative)
    creative_map[:creative][:title].should eq new_title
    creative_map[:creative][:url].should eq new_url
    creative_map[:creative][:body].should eq new_body
    creative_map[:creative][:ad_type_id].should eq new_ad_type_id
    creative_map[:creative][:script_body].should eq new_script_body
    creative_map[:creative][:is_active].should eq new_is_active
    creative_map[:creative][:alt].should eq new_alt
    creative_map[:creative][:is_sync].should eq new_is_sync
    creative_map[:creative][:image_name].should eq new_image_name
    
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
          :id => $creative_id
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
          :id => $creative_id
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
