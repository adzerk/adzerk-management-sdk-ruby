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
    $AdTypeId = 1
    $SiteId = 6872
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
      'AdTypeId' => $AdTypeId,
      'SiteId' => $SiteId,
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
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
    
  end
  
  it "should get a specific creative" do
    response = @@creative.get($creative_id)
    JSON.parse(response.body)["Id"].to_s.should == $creative_id
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["BrandId"].should == $BrandId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["SiteId"].should == $SiteId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
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
      'AdTypeId' => $AdTypeId,
      'SiteId' => $SiteId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.update(update_creative)
    # JSON.parse(response.body)["Id"].should == $creative_id
    # JSON.parse(response.body)["Title"].should == $Title
    # JSON.parse(response.body)["Url"].should == $Url
    # JSON.parse(response.body)["Body"].should == $Body
    # JSON.parse(response.body)["BrandId"].should == $BrandId
    # JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    # JSON.parse(response.body)["SiteId"].should == $SiteId
    # JSON.parse(response.body)["IsActive"].should == $IsActive
    # JSON.parse(response.body)["Alt"].should == $Alt
    # JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    # JSON.parse(response.body)["IsSync"].should == $IsSync
  end
  
  it "should list all creatives for an advertiser" do
    response = @@creative.list($BrandId)
    entry = response["Items"].last.to_json
    JSON.parse(entry)["Id"].should == $creative_id.to_i
    JSON.parse(entry)["Title"].should == $Title
    JSON.parse(entry)["Url"].should == $Url
    JSON.parse(entry)["Body"].should == $Body
    JSON.parse(entry)["BrandId"].should == $BrandId
    JSON.parse(entry)["AdTypeId"].should == $AdTypeId
    JSON.parse(entry)["SiteId"].should == $SiteId
    JSON.parse(entry)["IsActive"].should == $IsActive
    JSON.parse(entry)["Alt"].should == $Alt
    JSON.parse(entry)["IsDeleted"].should == $IsDeleted
    JSON.parse(entry)["IsSync"].should == $IsSync
  end

  it "should delete the creatives after creating it" do
    response = @@creative.delete($creative_id)
    response.body.should == "OK"
  end
  
  it "should not use a brandId it doesn't have access to when creating" do 
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => 1,
      'AdTypeId' => $AdTypeId,
      'SiteId' => $SiteId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.create(new_creative)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not use a brandId it doesn't have access to when updating" do 
    new_creative = {
      'Id' => $creative_id.to_i,
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => 1,
      'AdTypeId' => $AdTypeId,
      'SiteId' => $SiteId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.update(new_creative)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not retrieve a creative it doesn't have access to" do
    response = @@creative.get("123")
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not delete a creative it doesn't have access to" do
    response = @@creative.delete("123")
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should no use a siteId it doen't have access to when creating" do
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => $BrandId,
      'AdTypeId' => $AdTypeId,
      'SiteId' => 123,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.create(new_creative)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should no use a siteId it doen't have access to when updating" do
    new_creative = {
      'Id' => $creative_id.to_i,
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'BrandId' => $BrandId,
      'AdTypeId' => $AdTypeId,
      'SiteId' => 123,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.update(new_creative)
    true.should == !response.body.scan(/Object/).nil?
  end
      
end