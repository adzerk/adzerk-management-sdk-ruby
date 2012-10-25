require './spec_helper'

describe "Creative API" do
  
  $creative_url = 'http://www.adzerk.com'
  @@creative = $adzerk::Creative.new
  @@advertiser = $adzerk::Advertiser.new
  
  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    response = @@advertiser.create(new_advertiser)
    $advertiserId = JSON.parse(response.body)["Id"]
  end
  
  it "should create a creative using old api spec" do
      $Title = 'Test creative ' + rand(1000000).to_s
      $ImageName = ""
      $Url = "http://adzerk.com"
      $Body = "Test text"
      $AdvertiserId = $advertiserId
      $AdTypeId = 18
      $IsActive = true
      $Alt = "test alt"
      $IsDeleted = false
      $IsSync = false
      $IsHTMLJS = true
      $ScriptBody = "<html>"
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'AdvertiserId' => $AdvertiserId,
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
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
  end

  it "should create a creative using new api fields" do
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'AdvertiserId' => $AdvertiserId,
      'AdTypeId' => $AdTypeId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync,
      'IsHTMLJS' => $IsHTMLJS,
      'ScriptBody' => $ScriptBody
    }
    response = @@creative.create(new_creative, '250x250.gif')
    $creative_id = JSON.parse(response)["Id"].to_s
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
    JSON.parse(response.body)["IsHTMLJS"].should == $IsHTMLJS
    JSON.parse(response.body)["ScriptBody"].should == $ScriptBody
  end

  it "should get a specific creative" do
    response = @@creative.get($creative_id)
    JSON.parse(response.body)["Id"].to_s.should == $creative_id
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
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
      'AdvertiserId' => $AdvertiserId,
      'AdTypeId' => $AdTypeId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync
    }
    response = @@creative.update(update_creative)
    JSON.parse(response.body)["Id"].should == $creative_id.to_i
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
  end

  it "should update a specific creative with html ad" do
    update_creative = {
      'Id' => $creative_id.to_i,
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'AdvertiserId' => $AdvertiserId,
      'AdTypeId' => $AdTypeId,
      'IsActive' => $IsActive,
      'Alt' => $Alt,
      'IsDeleted' => $IsDeleted,
      'IsSync' => $IsSync,
      'IsHTMLJS' => true,
      'ScriptBody' => "<html></html>"
    }
    response = @@creative.update(update_creative)
    JSON.parse(response.body)["Id"].should == $creative_id.to_i
    JSON.parse(response.body)["Title"].should == $Title
    JSON.parse(response.body)["Url"].should == $Url
    JSON.parse(response.body)["Body"].should == $Body
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
    JSON.parse(response.body)["IsHTMLJS"].should == true 
    JSON.parse(response.body)["ScriptBody"].should == "<html></html>"
  end


  it "should list all creatives for an advertiser" do
    response = @@creative.list($AdvertiserId)
    entry = response["Items"].last.to_json
    JSON.parse(entry)["Id"].should == $creative_id.to_i
    JSON.parse(entry)["Title"].should == $Title
    JSON.parse(entry)["Url"].should == $Url
    JSON.parse(entry)["Body"].should == $Body
    JSON.parse(entry)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(entry)["AdTypeId"].should == $AdTypeId
    JSON.parse(entry)["IsActive"].should == $IsActive
    JSON.parse(entry)["Alt"].should == $Alt
    JSON.parse(entry)["IsDeleted"].should == $IsDeleted
    JSON.parse(entry)["IsSync"].should == $IsSync
  end

  #it "should update a creative with no adtype and preserve the adtype" do
    #updated_creative = {
      #'Id' => $creative_id,
      #'Title' => 'test',
      #'Body' => 'test',
      #'AdvertiserId' => $advertiserId,
      ##'AdTypeId' => 18,
      #'IsActive' => true,
      #'Alt' => "",
      #'IsDeleted' => false,
      #'IsSync' => false 
    #}
    #response = @@creative.update(updated_creative)
    #JSON.parse(response.body)["Title"].should == 'test'
    #JSON.parse(response.body)["Body"].should == 'test'
    #JSON.parse(response.body)["AdvertiserId"].should == $advertiserId
    #JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
  #end

  it "should delete the creatives after creating it" do
    response = @@creative.delete($creative_id)
    response.body.should == '"Successfully deleted"'
  end

  it "should not use a AdvertiserId it doesn't have access to when creating" do 
    new_creative = {
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'AdvertiserId' => 1,
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

  it "should not use a AdvertiserId it doesn't have access to when updating" do 
    new_creative = {
      'Id' => $creative_id.to_i,
      'Title' => $Title,
      'ImageName' => $ImageName,
      'Url' => $Url,
      'Body' => $Body,
      'AdvertiserId' => 1,
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

  it "should create a creative with no url or image name passed in" do
    $Url = "http://adzerk.com"
    $Body = "Test text"
    $AdvertiserId = $advertiserId
    $AdTypeId = 18
    $IsActive = true
    $Alt = "test alt"
    $IsDeleted = false
    $IsSync = false
    
    new_creative = {
      'Title' => $Title,
      'Body' => $Body,
      'AdvertiserId' => $AdvertiserId,
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
    JSON.parse(response.body)["AdvertiserId"].should == $AdvertiserId
    JSON.parse(response.body)["AdTypeId"].should == $AdTypeId
    JSON.parse(response.body)["IsActive"].should == $IsActive
    JSON.parse(response.body)["Alt"].should == $Alt
    JSON.parse(response.body)["IsDeleted"].should == $IsDeleted
    JSON.parse(response.body)["IsSync"].should == $IsSync
    
  end

end