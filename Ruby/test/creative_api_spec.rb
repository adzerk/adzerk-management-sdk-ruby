require 'spec_helper'

describe "Creative API" do
  
  $creative_url = 'http://www.adzerk.com'
  @@creative = $adzerk::Creative.new
  
  it "should create a creative" do
    $Title = 'Test creative ' + rand(1000000).to_s
    $ImageName = "test.jpg"
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $BrandId = 391
    $CampaignId = 1064
    $FlightId = 3230
    $MapId = 0
    $AdTypeId = 1
    $ZoneId = 0
    $SiteId = 0
    $ChannelId = 1196
    $SizeOverride = false
    $Iframe = false
    $PublisherAccountId = 372
    $ScriptBody = nil
    $Impressions = 100000
    $Percentage = 0
    $DistributionType = 0
    $AdFormatId = 1064
    $IsActive = true
    $Alt = "test alt"
    $IsDeleted = false
    $IsSync = false
    
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => $BrandId,
      'CampaignId' => $CampaignId,
      'FlightId' => $FlightId,
      'MapId' => $MapId,
      'AdTypeId' => $AdTypeId,
      'ZoneId' => $ZoneId,
      'SiteId' => $SiteId,
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'Percentage' => $Percentage,
      'DistributionType' => $DistributionType,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.create(new_creative)
    $creative_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["BrandId"].should == $BrandId
    JSON.parse(response.body)["CampaignId"].should == $CampaignId
    JSON.parse(response.body)["FlightId"].should == $FlightId
    JSON.parse(response.body)["MapId"].should == $MapId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["ZoneId"].should == $ZoneId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    JSON.parse(response.body)["ChannelId"].should == $ChannelId
    JSON.parse(response.body)["SizeOverride"].should == $SizeOverride
    #JSON.parse(response.body)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
    #JSON.parse(response.body)["Impressions"].should == $Impressions
    JSON.parse(response.body)["Percentage"].should == $Percentage
    JSON.parse(response.body)["DistributionType"].should == $DistributionType
    #JSON.parse(response.body)["AdFormatId"].should == $AdFormatId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].downcase.should == $IsDeleted.to_s
    JSON.parse(response.body)["IsSync"].should == $IsSync
    
  end
  
  it "should get a specific creative" do
    response = @@creative.get($creative_id)
    JSON.parse(response.body)["Id"].to_s.should == $creative_id
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["BrandId"].should == $BrandId
    #JSON.parse(response.body)["CampaignId"].should == $CampaignId
    #JSON.parse(response.body)["FlightId"].should == $FlightId
    JSON.parse(response.body)["MapId"].should == $MapId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["ZoneId"].should == $ZoneId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    #JSON.parse(response.body)["ChannelId"].should == $ChannelId
    JSON.parse(response.body)["SizeOverride"].should == $SizeOverride
    #JSON.parse(response.body)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
    #JSON.parse(response.body)["Impressions"].should == $Impressions
    JSON.parse(response.body)["Percentage"].should == $Percentage
    JSON.parse(response.body)["DistributionType"].should == $DistributionType
    #JSON.parse(response.body)["AdFormatId"].should == $AdFormatId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].downcase.should == $IsDeleted.to_s
    JSON.parse(response.body)["IsSync"].should == $IsSync
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
      'MapId' => $MapId,
      'AdTypeId' => $AdTypeId,
      'ZoneId' => $ZoneId,
      'SiteId' => $SiteId,
      'ChannelId' => $ChannelId,
      'SizeOverride' => $SizeOverride,
      'Iframe' => $Iframe,
      'PublisherAccountId' => $PublisherAccountId,
      'ScriptBody' => $ScriptBody,
      'Impressions' => $Impressions,
      'Percentage' => $Percentage,
      'DistributionType' => $DistributionType,
      'AdFormatId' => $AdFormatId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.update(update_creative)
    # JSON.parse(response.body)["Title"].should == $Title
    # JSON.parse(response.body)["Url"].should == $Url
    # JSON.parse(response.body)["Body"].should == $Body
    # JSON.parse(response.body)["BrandId"].should == $BrandId
    # JSON.parse(response.body)["CampaignId"].should == $CampaignId
    # JSON.parse(response.body)["FlightId"].should == $FlightId
    # JSON.parse(response.body)["MapId"].should == $MapId
    # JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
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
    # JSON.parse(response.body)["IsActive"].should == $IsActive
    # JSON.parse(response.body)["Alt"].should == $Alt
    # JSON.parse(response.body)["IsDeleted"].downcase.should == $IsDeleted.to_s
    # JSON.parse(response.body)["IsSync"].should == $IsSync
  end
  
  it "should list all creatives for a flight" do
    response = @@creative.list($FlightId)
    entry = response["Items"].last.to_json
    JSON.parse(entry)["Title"].should == $Title
    JSON.parse(entry)["Url"].should == $Url
    JSON.parse(entry)["Body"].should == $Body
    JSON.parse(entry)["BrandId"].should == $BrandId
    #JSON.parse(entry)["CampaignId"].should == $CampaignId
    #JSON.parse(entry)["FlightId"].should == $FlightId
    JSON.parse(entry)["MapId"].should == $MapId
    JSON.parse(entry)["AdTypeId"].should == $AdTypeId
    JSON.parse(entry)["ZoneId"].should == $ZoneId
    JSON.parse(entry)["SiteId"].should == $SiteId
    #JSON.parse(entry)["ChannelId"].should == $ChannelId
    JSON.parse(entry)["SizeOverride"].should == $SizeOverride
    #JSON.parse(entry)["PublisherAccountId"].should == $PublisherAccountId
    JSON.parse(entry)["ScriptBody"].should == $ScriptBody
    #JSON.parse(entry)["Impressions"].should == $Impressions
    JSON.parse(entry)["Percentage"].should == $Percentage
    JSON.parse(entry)["DistributionType"].should == $DistributionType
    #JSON.parse(entry)["AdFormatId"].should == $AdFormatId
    JSON.parse(entry)["IsActive"].should == $IsActive
    JSON.parse(entry)["Alt"].should == $Alt
    JSON.parse(entry)["IsDeleted"].downcase.should == $IsDeleted.to_s
    JSON.parse(entry)["IsSync"].should == $IsSync
  end
  
  it "should delete the creatives after creating it" do
    response = @@creative.delete($creative_id)
    response.body.should == "OK"
  end
    
end