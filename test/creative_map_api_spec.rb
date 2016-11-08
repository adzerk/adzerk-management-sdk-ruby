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
      :is_deleted => false,
      :goal_type => 1
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

  after(:all) do
    @flights.delete(@flight_id)
    @campaigns.delete(@campaign_id)
    @advertisers.delete(@advertiser_id)
    @priorities.delete(@priority_id)
    @channels.delete(@channel_id)
    @zones.delete(@zone_id)
    @sites.delete(@site_id)
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
    $CustomTargeting = '$keywords contains "bjork"'

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
      :custom_targeting => $CustomTargeting,
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
    expect(creative_map[:campaign_id]).to eq(@campaign_id)
    expect(creative_map[:flight_id]).to eq(@flight_id)
    #unless distribution type is Fixed (3) this value is ignored
    expect(creative_map[:impressions]).to eq($Impressions)
    expect(creative_map[:percentage]).to eq($Percentage)
    expect(creative_map[:site_id]).to eq(@site_id)
    expect(creative_map[:zone_id]).to eq(@zone_id)
    expect(creative_map[:distribution_type]).to eq($DistributionType)
    expect(creative_map[:is_active]).to eq($IsMapActive)
    expect(creative_map[:is_deleted]).to eq($IsMapDeleted)
    expect(creative_map[:custom_targeting]).to eq($CustomTargeting)

    expect(creative_map[:creative][:title]).to eq($Title)
    expect(creative_map[:creative][:url]).to eq($Url)
    expect(creative_map[:creative][:body]).to eq($Body)
    expect(creative_map[:creative][:advertiser_id]).to eq(@advertiser_id)
    expect(creative_map[:creative][:ad_type_id]).to eq($AdTypeId)
    expect(creative_map[:creative][:is_htmljs]).to eq($IsHTMLJS)
    expect(creative_map[:creative][:script_body]).to eq($ScriptBody)
    expect(creative_map[:creative][:is_active]).to eq($IsCreativeActive)
    expect(creative_map[:creative][:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative_map[:creative][:alt]).to eq($Alt)
    expect(creative_map[:creative][:is_sync]).to eq($IsSync)

    $creative_id = creative_map[:creative][:id]
  end

  it "should list all creatives maps for a flight" do
    creative_maps = @creative_maps.list(@flight_id)
    creative_map = creative_maps[:items].last
    $map_id= creative_map[:id]

    expect(creative_map[:campaign_id]).to eq(@campaign_id)
    expect(creative_map[:flight_id]).to eq(@flight_id)
    expect(creative_map[:impressions]).to eq($Impressions)
    expect(creative_map[:percentage]).to eq($Percentage)
    expect(creative_map[:site_id]).to eq(@site_id)
    expect(creative_map[:zone_id]).to eq(@zone_id)
    expect(creative_map[:distribution_type]).to eq($DistributionType)
    expect(creative_map[:is_active]).to eq($IsMapActive)
    expect(creative_map[:is_deleted]).to eq($IsMapDeleted)
    expect(creative_map[:custom_targeting]).to eq($CustomTargeting)

    expect(creative_map[:creative][:title]).to eq($Title)
    expect(creative_map[:creative][:url]).to eq($Url)
    expect(creative_map[:creative][:body]).to eq($Body)
    expect(creative_map[:creative][:advertiser_id]).to eq(@advertiser_id)
    expect(creative_map[:creative][:ad_type_id]).to eq($AdTypeId)
    expect(creative_map[:creative][:is_htmljs]).to eq($IsHTMLJS)
    expect(creative_map[:creative][:script_body]).to eq($ScriptBody)
    expect(creative_map[:creative][:is_active]).to eq($IsCreativeActive)
    expect(creative_map[:creative][:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative_map[:creative][:alt]).to eq($Alt)
    expect(creative_map[:creative][:is_sync]).to eq($IsSync)
  end

  it "should get a specific creative map" do
    creative_map = @creative_maps.get($map_id, @flight_id)

    expect(creative_map[:campaign_id]).to eq(@campaign_id)
    expect(creative_map[:flight_id]).to eq(@flight_id)
    expect(creative_map[:impressions]).to eq($Impressions)
    expect(creative_map[:percentage]).to eq($Percentage)
    expect(creative_map[:site_id]).to eq(@site_id)
    expect(creative_map[:zone_id]).to eq(@zone_id)
    expect(creative_map[:distribution_type]).to eq($DistributionType)
    expect(creative_map[:is_active]).to eq($IsMapActive)
    expect(creative_map[:is_deleted]).to eq($IsMapDeleted)
    expect(creative_map[:custom_targeting]).to eq($CustomTargeting)

    expect(creative_map[:creative][:title]).to eq($Title)
    expect(creative_map[:creative][:url]).to eq($Url)
    expect(creative_map[:creative][:body]).to eq($Body)
    expect(creative_map[:creative][:advertiser_id]).to eq(@advertiser_id)
    expect(creative_map[:creative][:ad_type_id]).to eq($AdTypeId)
    expect(creative_map[:creative][:is_htmljs]).to eq($IsHTMLJS)
    expect(creative_map[:creative][:script_body]).to eq($ScriptBody)
    expect(creative_map[:creative][:is_active]).to eq($IsCreativeActive)
    expect(creative_map[:creative][:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative_map[:creative][:alt]).to eq($Alt)
    expect(creative_map[:creative][:is_sync]).to eq($IsSync)
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
    expect(creative_map[:percentage]).to eq(new_percentage)
    expect(creative_map[:impressions]).to eq(new_impressions)
    expect(creative_map[:is_active]).to eq(new_is_active)

    #make sure old values are unchanged
    expect(creative_map[:campaign_id]).to eq(@campaign_id)
    expect(creative_map[:flight_id]).to eq(@flight_id)
    expect(creative_map[:site_id]).to eq(@site_id)
    expect(creative_map[:zone_id]).to eq(@zone_id)
    expect(creative_map[:distribution_type]).to eq($DistributionType)
    expect(creative_map[:is_deleted]).to eq($IsMapDeleted)

    expect(creative_map[:creative][:title]).to eq($Title)
    expect(creative_map[:creative][:url]).to eq($Url)
    expect(creative_map[:creative][:body]).to eq($Body)
    expect(creative_map[:creative][:advertiser_id]).to eq(@advertiser_id)
    expect(creative_map[:creative][:ad_type_id]).to eq($AdTypeId)
    expect(creative_map[:creative][:is_htmljs]).to eq($IsHTMLJS)
    expect(creative_map[:creative][:script_body]).to eq($ScriptBody)
    expect(creative_map[:creative][:is_active]).to eq($IsCreativeActive)
    expect(creative_map[:creative][:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative_map[:creative][:alt]).to eq($Alt)
    expect(creative_map[:creative][:is_sync]).to eq($IsSync)
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
    expect(creative_map[:creative][:title]).to eq new_title
    expect(creative_map[:creative][:url]).to eq new_url
    expect(creative_map[:creative][:body]).to eq new_body
    expect(creative_map[:creative][:ad_type_id]).to eq new_ad_type_id
    expect(creative_map[:creative][:script_body]).to eq new_script_body
    expect(creative_map[:creative][:is_active]).to eq new_is_active
    expect(creative_map[:creative][:alt]).to eq new_alt
    expect(creative_map[:creative][:is_sync]).to eq new_is_sync
    expect(creative_map[:creative][:image_name]).to eq new_image_name

  end

  it "should delete the creatives after creating it" do
    response = @creative_maps.delete($map_id, @flight_id)
    expect(response.body).to eq("\"This creative map has been deleted\"")
  end

  it "should not get a map in a different network" do
    expect{ @creative_maps.get(123, @flight_id) }.to raise_error "This PassCreativeMap does not belong to your network."
  end

  it "should get a map that's been deleted" do
    map = @creative_maps.get($map_id, @flight_id)
    expect(map[:is_deleted]).to eq(true)
  end

  it "should not update a map that's in a different network" do
    expect {
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
    }.to raise_error "This Flight does not belong to your network."
  end

  it "should not update a map that's been deleted" do
    expect {
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
    }.to raise_error "This creative map has been deleted"
  end

  it "should fail when creating a map for a campaign in a different network" do
    expect {
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
    }.to raise_error "This campaign is not part of your network"
  end

  it "should fail when creating a map for a site in a different network" do
    expect {
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
    }.to raise_error "This site does not belong to your network"
  end

  it "should fail when creating a map for a zone in a different network" do
    expect {
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
    }.to raise_error "The site associated with that zone does not belong to your network"
  end
end
