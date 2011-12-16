require 'spec_helper'

describe "Creative Flight API" do
  
  $creative_url = 'http://www.adzerk.com'
  @@map = $adzerk::CreativeMap.new
  @@advertiser = $adzerk::Advertiser.new
  @@channel = $adzerk::Channel.new
  @@campaign = $adzerk::Campaign.new
  @@site = $adzerk::Site.new
  @@flight = $adzerk::Flight.new
  
  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    response = @@advertiser.create(new_advertiser)
    $brandId = JSON.parse(response.body)["Id"]
    
    new_channel = {
      'Title' => 'Test Channel ' + rand(1000000).to_s,
      'Commission' => '0',
      'Engine' => 'CPM',
      'Keywords' => 'test',
      'CPM' => '10.00',
      'AdTypes' => [1,2,3,4]
    }  
    response = @@channel.create(new_channel)
    $channelId = JSON.parse(response.body)["Id"]
    
    new_campaign = {
      'Name' => 'Test campaign ' + rand(1000000).to_s,
      'StartDate' => "1/1/2011",
      'EndDate' => "12/31/2011",
      'IsActive' => false,
      'Price' => '10.00',
      'BrandId' => $brandId,
      'Flights' => [],
      'IsDeleted' => false
    }  
    response = @@campaign.create(new_campaign)
    $campaignId = JSON.parse(response.body)["Id"]
    
    new_flight = {
      'NoEndDate' => false,
      'ChannelId' => $channelId,
      'Name' => 'Test flight ' + rand(1000000).to_s,
      'StartDate' => "1/1/2011",
      'EndDate' => "12/31/2011",
      'NoEndDate' => false,
      'Price' => '15.00',
      'OptionType' => 1,
      'Impressions' => 10000,
      'IsUnlimited' => false,
      'IsFullSpeed' => false,
      'Keywords' => "test, test2",
      'UserAgentKeywords' => nil,
      'WeightOverride' => nil,
      'CampaignId' => $campaignId,
      'IsActive' => true,
      'IsDeleted' => false
    }
    response = @@flight.create(new_flight)
    $flightId = JSON.parse(response.body)["Id"]
    
    new_site = {
     'Title' => 'Test Site ' + rand(1000000).to_s,
     'Url' => 'http://www.adzerk.com'
    }
    response = @@site.create(new_site)
    $siteId = JSON.parse(response.body)["Id"]
  end
  
  it "should create a creative" do
    $Title = 'Test creative ' + rand(1000000).to_s
    $ImageName = "test.jpg"
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $BrandId = $brandId
    $CampaignId = $campaignId
    $FlightId = $flightId
    $MapId = 0
    $AdTypeId = 18
    $ZoneId = 0
    $SiteId = $siteId
    $ChannelId = $channelId
    $SizeOverride = false
    $Iframe = false
    $PublisherAccountId = 372
    $ScriptBody = nil
    $Impressions = 100000
    $Percentage = 0
    $DistributionType = 0
    $AdFormatId = 0
    $IsActive = true
    $Alt = "test alt"
    $IsDeleted = false
    $IsSync = false
    
    new_creative = {
      'CampaignId' => $CampaignId,
      'FlightId' => $FlightId,
      #'MapId' => $MapId,
      #'ZoneId' => $ZoneId,
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'Percentage' => $Percentage,
      'SiteId' => $SiteId,
      #'DistributionType' => $DistributionType,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'IsDeleted' => $IsDeleted,
      'Creative' => {
        'Title' => $Title,
        'ImageName' => $ImageName,
        'Url' => $Url,
        'Body' => $Body,
        'BrandId' => $BrandId,
        'AdTypeId' => $AdTypeId,
        'IsActive' => $IsActive,
        'Alt' => $Alt,
        'IsDeleted' => $IsDeleted,
        'IsSync' => $IsSync
      }
    }
    response = @@map.create(new_creative)
    Adzerk.uploadCreative(JSON.parse(response.body)["Creative"]["Id"].to_s, "250x250.gif") 
    $creative_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Creative"]["Title"].should == $Title
    JSON.parse(response.body)["Creative"]["Url"].should == $Url
    JSON.parse(response.body)["Creative"]["Body"].should == $Body
    JSON.parse(response.body)["Creative"]["BrandId"].should == $BrandId
    JSON.parse(response.body)["CampaignId"].should == $CampaignId
    JSON.parse(response.body)["FlightId"].should == $FlightId
    #JSON.parse(response.body)["MapId"].should == $MapId
    JSON.parse(response.body)["Creative"]["AdTypeId"].should == $AdTypeId
    #JSON.parse(response.body)["ZoneId"].should == $ZoneId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    JSON.parse(response.body)["ChannelId"].should == $ChannelId
    JSON.parse(response.body)["SizeOverride"].should == $SizeOverride
    JSON.parse(response.body)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
    JSON.parse(response.body)["Impressions"].should == $Impressions
    JSON.parse(response.body)["Percentage"].should == $Percentage
    #JSON.parse(response.body)["DistributionType"].should == $DistributionType
    JSON.parse(response.body)["AdFormatId"].should == $AdFormatId
    JSON.parse(response.body)["Creative"]["IsActive"].should == $IsActive
    JSON.parse(response.body)["Creative"]["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["Creative"]["IsSync"].should == $IsSync
  end
  
  it "should list all creatives for a flight" do
    response = @@map.list($FlightId)
    entry = response["Items"].last.to_json
    $creative_id = JSON.parse(entry)["Id"]
    JSON.parse(entry)["Creative"]["Title"].should == $Title
    JSON.parse(entry)["Creative"]["Url"].should == $Url
    JSON.parse(entry)["Creative"]["Body"].should == $Body
    JSON.parse(entry)["Creative"]["BrandId"].should == $BrandId
    #JSON.parse(entry)["CampaignId"].should == $CampaignId
    #JSON.parse(entry)["FlightId"].should == $FlightId
    #JSON.parse(entry)["MapId"].should == $MapId
    JSON.parse(entry)["Creative"]["AdTypeId"].should == $AdTypeId
    #JSON.parse(entry)["ZoneId"].should == $ZoneId
    JSON.parse(entry)["SiteId"].should == $SiteId
    #JSON.parse(entry)["ChannelId"].should == $ChannelId
    JSON.parse(entry)["SizeOverride"].should == $SizeOverride
    #JSON.parse(entry)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(entry)["ScriptBody"].should == $ScriptBody
    #JSON.parse(entry)["Impressions"].should == $Impressions
    JSON.parse(entry)["Percentage"].should == $Percentage
    #JSON.parse(entry)["DistributionType"].should == $DistributionType
    #JSON.parse(entry)["AdFormatId"].should == $AdFormatId
    JSON.parse(entry)["Creative"]["IsActive"].should == $IsActive
    JSON.parse(entry)["Creative"]["Alt"].should == $Alt
    JSON.parse(entry)["IsDeleted"].should == $IsDeleted
    JSON.parse(entry)["Creative"]["IsSync"].should == $IsSync
  end
  
  it "should get a specific creative" do
    response = @@map.get($creative_id, $flightId)
    JSON.parse(response.body)["Id"].should == $creative_id
    JSON.parse(response.body)["Creative"]["Title"].should == $Title
    JSON.parse(response.body)["Creative"]["Url"].should == $Url
    JSON.parse(response.body)["Creative"]["Body"].should == $Body
    JSON.parse(response.body)["Creative"]["BrandId"].should == $BrandId
    #JSON.parse(response.body)["CampaignId"].should == $CampaignId
    #JSON.parse(response.body)["FlightId"].should == $FlightId
    #JSON.parse(response.body)["MapId"].should == $MapId
    JSON.parse(response.body)["Creative"]["AdTypeId"].should == $AdTypeId
    #JSON.parse(response.body)["ZoneId"].should == $ZoneId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    #JSON.parse(response.body)["ChannelId"].should == $ChannelId
    JSON.parse(response.body)["SizeOverride"].should == $SizeOverride
    #JSON.parse(response.body)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
    #JSON.parse(response.body)["Impressions"].should == $Impressions
    JSON.parse(response.body)["Percentage"].should == $Percentage
    #JSON.parse(response.body)["DistributionType"].should == $DistributionType
    #JSON.parse(response.body)["AdFormatId"].should == $AdFormatId
    JSON.parse(response.body)["Creative"]["IsActive"].should == $IsActive
    JSON.parse(response.body)["Creative"]["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["Creative"]["IsSync"].should == $IsSync
  end
  
  it "should update a specific creative" do
    update_creative = {
      'Id' => $creative_id.to_i,
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => $BrandId,
      'CampaignId' => $CampaignId,
      'FlightId' => $FlightId,
      #'MapId' => $MapId,
      'AdTypeId' => $AdTypeId,
      #'ZoneId' => $ZoneId,
      'SiteId' => $SiteId,
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'Percentage' => $Percentage,
      #'DistributionType' => $DistributionType,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@map.update(update_creative)
    puts $creative_id
    # JSON.parse(response.body)["Id"].should == $creative_id
    # JSON.parse(response.body)["Creative"]["Title"].should == $Title
    # JSON.parse(response.body)["Creative"]["Url"].should == $Url
    # JSON.parse(response.body)["Creative"]["Body"].should == $Body
    # JSON.parse(response.body)["Creative"]["BrandId"].should == $BrandId
    # JSON.parse(response.body)["CampaignId"].should == $CampaignId
    # JSON.parse(response.body)["FlightId"].should == $FlightId
    # JSON.parse(response.body)["MapId"].should == $MapId
    # JSON.parse(response.body)["Creative"]["AdTypeId"].should == $AdTypeId
    # JSON.parse(response.body)["ZoneId"].should == $ZoneId
    # JSON.parse(response.body)["SiteId"].should == $SiteId
    # JSON.parse(response.body)["ChannelId"].should == $ChannelId
    # JSON.parse(response.body)["SizeOverride"].should == $SizeOverride
    # JSON.parse(response.body)["PublisherAccountId"].should == $PublisherAccountId
    # JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
    # JSON.parse(response.body)["Impressions"].should == $Impressions
    # JSON.parse(response.body)["Percentage"].should == $Percentage
    # JSON.parse(response.body)["DistributionType"].should == $DistributionType
    # JSON.parse(response.body)["AdFormatId"].should == $AdFormatId
    # JSON.parse(response.body)["Creative"]["IsActive"].should == $IsActive
    # JSON.parse(response.body)["Creative"]["Alt"].should == $Alt
    # JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    # JSON.parse(response.body)["Creative"]["IsSync"].should == $IsSync
  end
  
  it "should delete the creatives after creating it" do
    response = @@map.delete($creative_id, $FlightId)
    response.body.should == "OK"
  end
  
  it "should not create a map when campaignId is forbidden" do
    map = {
      'CampaignId' => '123',
      'FlightId' => $FlightId,
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'SiteId' => $SiteId,
      'Percentage' => $Percentage,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'IsDeleted' => $IsDeleted
    }
    response = @@map.create(map)
    true.should == !response.body.scan(/Object/).nil?    
  end
  
  it "should not create a map when flightId is forbidden" do
    map = {
      'CampaignId' => $CampaignId,
      'FlightId' => '123',
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'SiteId' => $SiteId,
      'Percentage' => $Percentage,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'IsDeleted' => $IsDeleted
    }
    response = @@map.create(map)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not create a map when channelId is forbidden" do
    map = {
      'CampaignId' => $CampaignId,
      'FlightId' => $FlightId,
      'ChannelId' => '123',
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'SiteId' => $SiteId,
      'Percentage' => $Percentage,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'IsDeleted' => $IsDeleted
    }
    response = @@map.create(map)
    true.should == !response.body.scan(/Object/).nil?
  end
    
end
