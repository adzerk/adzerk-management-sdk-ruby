require 'spec_helper'

describe "Campaign API" do
  
  $campaign_url = 'http://www.adzerk.com'
  @@campaign = $adzerk::Campaign.new
  
  it "should create a new campaign with no flights" do
    $campaign_Name = 'Test campaign ' + rand(1000000).to_s
    $campaign_StartDate = "1/1/2011"
    $campaign_EndDate = "12/31/2011"
    $campaign_IsActive = false
    $campaign_Price = '10.00'
    $campaign_BrandId = 391
    $campaign_Flights = []
    
    new_campaign = {
      'Name' => $campaign_Name,
      'StartDate' => $campaign_StartDate,
      'EndDate' => $campaign_EndDate,
      'IsActive' => $campaign_IsActive,
      'Price' => $campaign_Price,
      'BrandId' => $campaign_BrandId,
      'Flights' => $campaign_Flights,
      'IsDeleted' => false
    }
  
    response = @@campaign.create(new_campaign)
    $campaign_id = JSON.parse(response.body)["Id"].to_s
    $campaign_Name.should == JSON.parse(response.body)["Name"]
    #$campaign_StartDate.should == JSON.parse(response.body)["StartDate"]
    #$campaign_EndDate.should == JSON.parse(response.body)["EndDate"]
    $campaign_IsActive.should == JSON.parse(response.body)["IsActive"]
    $campaign_Price.to_f.should == JSON.parse(response.body)["Price"]
    $campaign_BrandId.should == JSON.parse(response.body)["BrandId"]
    JSON.parse(response.body)["IsDeleted"].should == false
    $campaign_Flights.should == JSON.parse(response.body)["Flights"]
  end
  
  it "should create a new campaign with one flight" do
    $campaign_Flights1 = [{
      'StartDate' => "1/1/2011",
      'EndDate' => "12/31/2011",
      'NoEndDate' => false,
      'Price' => "5.00",
      'Keywords' => "test, test2",
      'Name' => "Test",
      'ChannelId' => 1196,
      'Impressions' => 10000,
      'IsDeleted' => false
    }]
    new1_campaign = {
      'Name' => $campaign_Name,
      'StartDate' => $campaign_StartDate,
      'EndDate' => $campaign_EndDate,
      'IsActive' => $campaign_IsActive,
      'Price' => $campaign_Price,
      'BrandId' => $campaign_BrandId,
      'IsDeleted' => false,
      'Flights' => $campaign_Flights1
    }
    response = @@campaign.create(new1_campaign)
    $campaign_id1 = JSON.parse(response.body)["Id"].to_s
    $campaign_Name.should == JSON.parse(response.body)["Name"]
    #$campaign_StartDate.should == JSON.parse(response.body)["StartDate"]
    #$campaign_EndDate.should == JSON.parse(response.body)["EndDate"]
    $campaign_IsActive.should == JSON.parse(response.body)["IsActive"]
    JSON.parse(response.body)["IsDeleted"].should == false
    $campaign_Price.to_f.should == JSON.parse(response.body)["Price"]
    $campaign_BrandId.should == JSON.parse(response.body)["BrandId"]
    #$campaign_Flights1.to_json.should == JSON.parse(response.body)["Flights"]
  end
  
  it "should create a new campaign with two flights" do
    $campaign_Flights2 = [{
      'StartDate' => "1/1/2011",
      'EndDate' => "12/31/2011",
      'NoEndDate' => false,
      'Price' => "5.00",
      'Keywords' => "test, test2",
      'Name' => "Test",
      'ChannelId' => 1196,
      'Impressions' => 10000
    },{
      'StartDate' => "1/1/2010",
      'EndDate' => "12/31/2012",
      'NoEndDate' => false,
      'Price' => "10.00",
      'Keywords' => "test, test2, test3",
      'Name' => "Test3",
      'ChannelId' => 1196,
      'Impressions' => 15000
    }]
    new2_campaign = {
      'Name' => $campaign_Name,
      'StartDate' => $campaign_StartDate,
      'EndDate' => $campaign_EndDate,
      'IsActive' => $campaign_IsActive,
      'Price' => $campaign_Price,
      'BrandId' => $campaign_BrandId,
      'Flights' => $campaign_Flights2
    }
    response = @@campaign.create(new2_campaign)
    $campaign_id2 = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Flights"].length.should == 2
  end
  
  it "should list a specific campaign" do
    response = @@campaign.get($campaign_id)
    response.body.should == '{"Id":' + $campaign_id + ',"Name":"' + $campaign_Name + '","StartDate":"\/Date(1293858000000-0500)\/","EndDate":"\/Date(1325307600000-0500)\/","IsActive":false,"Price":' + $campaign_Price + ',"BrandId":' + $campaign_BrandId.to_s + ',"IsDeleted":false}'
  end
  
  it "should update a campaign" do
    $campaign_Name = 'Test campaign ' + rand(1000000).to_s
    $campaign_StartDate = "1/1/2011"
    $campaign_EndDate = "12/31/2011"
    $campaign_IsActive = false
    $campaign_Price = '10.00'
    $campaign_BrandId = 391
    $campaign_Flights = []
    
    new_campaign = {
      'Id' => $campaign_id,
      'Name' => $campaign_Name,
      'StartDate' => $campaign_StartDate,
      'EndDate' => $campaign_EndDate,
      'IsActive' => $campaign_IsActive,
      'Price' => $campaign_Price,
      'BrandId' => $campaign_BrandId,
      'Flights' => $campaign_Flights,
      'IsDeleted' => false
    }
  
    response = @@campaign.update(new_campaign)
    $campaign_id = JSON.parse(response.body)["Id"].to_s
    $campaign_Name.should == JSON.parse(response.body)["Name"]
    #$campaign_StartDate.should == JSON.parse(response.body)["StartDate"]
    #$campaign_EndDate.should == JSON.parse(response.body)["EndDate"]
    $campaign_IsActive.should == JSON.parse(response.body)["IsActive"]
    $campaign_Price.to_f.should == JSON.parse(response.body)["Price"]
    $campaign_BrandId.should == JSON.parse(response.body)["BrandId"]
    JSON.parse(response.body)["IsDeleted"].should == false
    $campaign_Flights.should == JSON.parse(response.body)["Flights"]
  end
  
  it "should list all campaigns" do
    result = @@campaign.list()
    result.length.should > 0
    # result["Items"].last["Id"].to_s.should == $campaign_id
    # result["Items"].last["Title"].should == $u_campaign_title
    # result["Items"].last["Commission"].should == $u_campaign_commission.to_f
    # result["Items"].last["Engine"].should == $u_campaign_engine
    # result["Items"].last["Keywords"].should == $u_campaign_keywords
    # result["Items"].last["CPM"].to_s.should == $u_campaign_CPM.to_f.to_s
    # result["Items"].last["AdTypes"].should == $u_campaign_AdTypes
  end
  
  it "should delete a new campaign" do
    response = @@campaign.delete($campaign_id)
    response.body.should == 'OK'
  end
  
  it "should not get individual deleted campaign" do
    response = @@campaign.get($campaign_id)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not update deleted campaigns" do
    updated_campaign = {
      'Id' => $campaign_id,
      'Name' => $campaign_Name,
      'StartDate' => $campaign_StartDate,
      'EndDate' => $campaign_EndDate,
      'IsActive' => $campaign_IsActive,
      'Price' => $campaign_Price,
      'BrandId' => $campaign_BrandId,
      'Flights' => $campaign_Flights,
      'IsDeleted' => false
    }
    response = @@campaign.update(updated_campaign)
  end

end
