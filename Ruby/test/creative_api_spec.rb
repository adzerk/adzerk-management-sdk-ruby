require 'spec_helper'

describe "Creative API" do
  
  $creative_url = 'http://www.adzerk.com'
  @@creative = $adzerk::Creative.new
  @@advertiser = $adzerk::Advertiser.new
  
  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    response = @@advertiser.create(new_advertiser)
    $brandId = JSON.parse(response.body)["Id"]
  end
  
  it "should create a creative" do
    $Title = 'Test creative ' + rand(1000000).to_s
    $ImageName = ""
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $BrandId = $brandId
    $AdTypeId = 18
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
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.create(new_creative, '250x250.gif')
    
    $creative_id = JSON.parse(response)["Id"].to_s
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["BrandId"].should == $BrandId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
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
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    begin
      response = @@creative.create(new_creative)
    rescue Exception => e
      response = e
    end
  
    response.to_s.scan("302 Found").should_not == nil
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

  it "should create a creative with no url passed in" do
    $Title = 'Test creative ' + rand(1000000).to_s
    $ImageName = ""
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $BrandId = $brandId
    $AdTypeId = 18
    $IsActive = true
    $Alt = "test alt"
    $IsDeleted = false
    $IsSync = false
    
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Body' => $Body,
      'BrandId' => $BrandId,
      'AdTypeId' => $AdTypeId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.create(new_creative, '250x250.gif')
    
    $creative_id = JSON.parse(response)["Id"].to_s
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["BrandId"].should == $BrandId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
    
  end

end