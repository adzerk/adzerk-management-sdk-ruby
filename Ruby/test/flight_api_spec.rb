require 'spec_helper'

describe "Flight API" do
  
  $flight_url = 'http://www.adzerk.com'
  @@flight = $adzerk::Flight.new
  
  it "should create a flight" do
    $flight_Name = 'Test flight ' + rand(1000000).to_s
    $flight_StartDate = "1/1/2011"
    $flight_EndDate = "12/31/2011"
    $flight_NoEndDate = false
    $flight_Price = '15.00'
    $flight_OptionType = 1
    $flight_Impressions = 10000
    $flight_IsUnlimited = false
    $flight_IsFullSpeed = false
    $flight_Keywords = "test, test2"
    $flight_UserAgentKeywords = nil
    $flight_WeightOverride = nil
    $flight_CampaignId = 1064
    $flight_IsActive = true
    $flight_IsDeleted = false
    
    new_flight = {
      'NoEndDate' => false,
      'ChannelId' => 1196,
      'Name' => $flight_Name,
      'StartDate' => $flight_StartDate,
      'EndDate' => $flight_EndDate,
      'NoEndDate' => $flight_NoEndDate,
      'Price' => $flight_Price,
      'OptionType' => $flight_OptionType,
      'Impressions' => $flight_Impressions,
      'IsUnlimited' => $flight_IsUnlimited,
      'IsFullSpeed' => $flight_IsFullSpeed,
      'Keywords' => $flight_Keywords,
      'UserAgentKeywords' => $flight_UserAgentKeywords,
      'WeightOverride' => $flight_WeightOverride,
      'CampaignId' => $flight_CampaignId,
      'IsActive' => $flight_IsActive,
      'IsDeleted' => $flight_IsDeleted
    }
    response = @@flight.create(new_flight)
    $flight_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["NoEndDate"].should == false
    JSON.parse(response.body)["ChannelId"].should == 1196
    JSON.parse(response.body)["Name"].should == $flight_Name
    JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    JSON.parse(response.body)["NoEndDate"].should == $flight_NoEndDate
    JSON.parse(response.body)["Price"].should == 15.0
    JSON.parse(response.body)["OptionType"].should == $flight_OptionType
    JSON.parse(response.body)["Impressions"].should == $flight_Impressions
    JSON.parse(response.body)["IsUnlimited"].should == $flight_IsUnlimited
    JSON.parse(response.body)["IsFullSpeed"].should == $flight_IsFullSpeed
    JSON.parse(response.body)["Keywords"].should == $flight_Keywords
    JSON.parse(response.body)["UserAgentKeywords"].should == $flight_UserAgentKeywords
    JSON.parse(response.body)["WeightOverride"].should == $flight_WeightOverride
    JSON.parse(response.body)["CampaignId"].should == $flight_CampaignId
    JSON.parse(response.body)["IsActive"].should == $flight_IsActive
    JSON.parse(response.body)["IsDeleted"].should == $flight_IsDeleted
  end  
  
  it "should list a specific flight" do
    response = @@flight.get($flight_id)
    response.body.should == '{"Id":' + $flight_id + ',"StartDate":"\\/Date(1293858000000-0500)\\/","EndDate":"\\/Date(1325307600000-0500)\\/","Price":15,"OptionType":1,"Impressions":10000,"IsUnlimited":false,"IsNoDuplicates":false,"IsFullSpeed":false,"Keywords":"test, test2","Name":"' + $flight_Name + '","CampaignId":1064,"ChannelId":0,"IsDeleted":false,"IsActive":true}'
  end
  
  it "should update a flight" do
    $u_flight_Name = 'Test Test flight ' + rand(1000000).to_s
    $u_flight_StartDate = "1/1/2011"
    $u_flight_EndDate = "12/31/2011"
    $u_flight_NoEndDate = false
    $u_flight_Price = '16.00'
    $u_flight_OptionType = 1
    $u_flight_Impressions = 12000
    $u_flight_IsUnlimited = false
    $u_flight_IsFullSpeed = false
    $u_flight_Keywords = "test, test2"
    $u_flight_UserAgentKeywords = nil
    $u_flight_WeightOverride = nil
    $u_flight_CampaignId = 1064
    $u_flight_IsActive = true
    $u_flight_IsDeleted = false
    
    new_flight = {
      'Id' => $flight_id,
      'NoEndDate' => false,
      'ChannelId' => 1196,
      'Name' => $u_flight_Name,
      'StartDate' => $u_flight_StartDate,
      'EndDate' => $u_flight_EndDate,
      'NoEndDate' => $u_flight_NoEndDate,
      'Price' => $u_flight_Price,
      'OptionType' => $u_flight_OptionType,
      'Impressions' => $u_flight_Impressions,
      'IsUnlimited' => $u_flight_IsUnlimited,
      'IsFullSpeed' => $u_flight_IsFullSpeed,
      'Keywords' => $u_flight_Keywords,
      'UserAgentKeywords' => $u_flight_UserAgentKeywords,
      'WeightOverride' => $u_flight_WeightOverride,
      'CampaignId' => $u_flight_CampaignId,
      'IsActive' => $u_flight_IsActive,
      'IsDeleted' => $u_flight_IsDeleted
    }
    response = @@flight.update(new_flight)
    $flight_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["NoEndDate"].should == false
    JSON.parse(response.body)["ChannelId"].should == 1196
    JSON.parse(response.body)["Name"].should == $u_flight_Name
    JSON.parse(response.body)["StartDate"].should == "/Date(1293858000000-0500)/"
    JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
    JSON.parse(response.body)["NoEndDate"].should == $u_flight_NoEndDate
    JSON.parse(response.body)["Price"].should == 16.0
    JSON.parse(response.body)["OptionType"].should == $u_flight_OptionType
    JSON.parse(response.body)["Impressions"].should == $u_flight_Impressions
    JSON.parse(response.body)["IsUnlimited"].should == $u_flight_IsUnlimited
    JSON.parse(response.body)["IsFullSpeed"].should == $u_flight_IsFullSpeed
    JSON.parse(response.body)["Keywords"].should == $u_flight_Keywords
    JSON.parse(response.body)["UserAgentKeywords"].should == $u_flight_UserAgentKeywords
    JSON.parse(response.body)["WeightOverride"].should == $u_flight_WeightOverride
    JSON.parse(response.body)["CampaignId"].should == $u_flight_CampaignId
    JSON.parse(response.body)["IsActive"].should == $u_flight_IsActive
    JSON.parse(response.body)["IsDeleted"].should == $u_flight_IsDeleted
  end
  
  it "should list all flights" do
    result = @@flight.list()
    result.length.should > 0
    ## Can't test this right now because of paging issues
    # result["Items"].last["Id"].to_s.should == $flight_id
    # result["Items"].last["NoEndDate"].should == false
    # result["Items"].last["ChannelId"].should == 1196
    # result["Items"].last["Name"].should == $flight_Name
    # result["Items"].last["StartDate"].should == "/Date(1293858000000-0500)/"
    # result["Items"].last["EndDate"].should == "/Date(1325307600000-0500)/"
    # result["Items"].last["NoEndDate"].should == $flight_NoEndDate
    # result["Items"].last["Price"].should == 15.0
    # result["Items"].last["OptionType"].should == $flight_OptionType
    # result["Items"].last["Impressions"].should == $flight_Impressions
    # result["Items"].last["IsUnlimited"].should == $flight_IsUnlimited
    # result["Items"].last["IsFullSpeed"].should == $flight_IsFullSpeed
    # result["Items"].last["Keywords"].should == $flight_Keywords
    # result["Items"].last["UserAgentKeywords"].should == $flight_UserAgentKeywords
    # result["Items"].last["WeightOverride"].should == $flight_WeightOverride
    # result["Items"].last["CampaignId"].should == $flight_CampaignId
    # result["Items"].last["IsActive"].should == $flight_IsActive
    # result["Items"].last["IsDeleted"].should == $flight_IsDeleted
  end
  
  it "should delete a new flight" do
    response = @@flight.delete($flight_id)
    response.body.should == 'OK'
  end

  it "should not get individual deleted flight" do
    response = @@flight.get($flight_id)
    response.body.should == '{"Id":0,"ChannelId":0,"IsDeleted":false,"IsActive":false}'
  end

end
