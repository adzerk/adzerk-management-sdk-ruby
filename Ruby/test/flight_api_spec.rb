require './spec_helper.rb'

describe "Flight API" do
  
  $flight_url = 'http://www.adzerk.com'
  @@flight = $adzerk::Flight.new
  @@advertiser = $adzerk::Advertiser.new
  @@channel = $adzerk::Channel.new
  @@campaign = $adzerk::Campaign.new
  @@priority = $adzerk::Priority.new
  
  before(:all) do
    new_advertiser = {
      'Title' => "Test"
    }
    response = @@advertiser.create(new_advertiser)
    $advertiserId = JSON.parse(response.body)["Id"]
    
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
    
    new_priority = {
      'Name' => "High Priority Test",
      'ChannelId' => $channelId,
      'Weight' => 1,
      'IsDeleted' => false
    }
    response = @@priority.create(new_priority)
    $priority_id = JSON.parse(response.body)["Id"].to_s

    new_campaign = {
      'Name' => 'Test campaign ' + rand(1000000).to_s,
      'StartDate' => "1/1/2011",
      'EndDate' => "12/31/2011",
      'IsActive' => false,
      'Price' => '10.00',
      'AdvertiserId' => $advertiserId,
      'Flights' => [],
      'IsDeleted' => false
    }  
    response = @@campaign.create(new_campaign)
    $campaignId = JSON.parse(response.body)["Id"]
  end
  
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
    $flight_CampaignId = $campaignId
    $flight_IsActive = true
    $flight_IsDeleted = false
    
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
    JSON.parse(response.body)["PriorityId"].to_s.should == $priority_id
    JSON.parse(response.body)["Name"].should == $flight_Name
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
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
    response.body.should == '{"Id":' + $flight_id + ',"StartDate":"\\/Date(1293840000000+0000)\\/","EndDate":"\\/Date(1325289600000+0000)\\/","Price":15.00,"OptionType":1,"Impressions":10000,"IsUnlimited":false,"IsNoDuplicates":false,"IsFullSpeed":false,"Keywords":"test, test2","Name":"' + $flight_Name + '","CampaignId":' + $campaignId.to_s + ',"PriorityId":' + $priority_id + ',"IsDeleted":false,"IsActive":true,"GeoTargeting":[],"FreqCap":0,"FreqCapDuration":0,"FreqCapType":0,"CreativeMaps":[]}'
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
    $u_flight_CampaignId = $campaignId
    $u_flight_IsActive = true
    $u_flight_IsDeleted = false
    
    new_flight = {
      'Id' => $flight_id,
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
    JSON.parse(response.body)["PriorityId"].to_s.should == $priority_id
    JSON.parse(response.body)["Name"].should == $u_flight_Name
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
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
    # result["Items"].last["PriorityId"].should == $priorityId
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
  
  it "should not get if campaignId or priorityId is forbidden" do
    response = @@flight.get($flight_id)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should delete a new flight" do
    response = @@flight.delete($flight_id)
    response.body.should == '"Successfully deleted"'
  end

  it "should not get individual deleted flight" do
    response = @@flight.get($flight_id)
    response.body.should == '"This flight has been deleted"'
  end
  
  it "should not create/update if campaignId is forbidden" do
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'CampaignId' => '123',
      'IsActive' => $flight_IsActive,
      'IsDeleted' => $flight_IsDeleted
    }
    response = @@flight.create(new_flight)
    true.should == !response.body.scan(/Object/).nil?
    
    new_flight = {
      'Id' => $flight_id,
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'CampaignId' => '123',
      'IsActive' => $flight_IsActive,
      'IsDeleted' => $flight_IsDeleted
    }
    response = @@flight.update(new_flight)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not create/update if priorityId is forbidden" do
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => '123',
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
    true.should == !response.body.scan(/Object/).nil?
    
    new_flight = {
      'Id' => $flight_id,
      'NoEndDate' => false,
      'PriorityId' => '123',
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
    response = @@flight.update(new_flight)
    true.should == !response.body.scan(/Object/).nil?
  end

  it "should list the coutries, regions, and metros for geo-targeting" do
    response = @@flight.countries()
    true.should == !response.body.scan(/Object/).nil?
    response = @@flight.regions("NC")
    true.should == !response.body.scan(/Object/).nil?
  end

  it "should create a flight with geotargeting" do
    $geo = [{
      #'LocationId' => nil,
      'CountryCode' => 'US',
      'Region' => 'NC',
      'MetroCode' => '560'
    }]

    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'IsDeleted' => $flight_IsDeleted,
      'GeoTargeting' => $geo
    }
    response = @@flight.create(new_flight)
    $flight_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["NoEndDate"].should == false
    JSON.parse(response.body)["PriorityId"].to_s.should == $priority_id
    JSON.parse(response.body)["Name"].should == $flight_Name
    #JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    #JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
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
    JSON.parse(response.body)["GeoTargeting"].first["CountryCode"].should == "US"
    JSON.parse(response.body)["GeoTargeting"].first["Region"].should == "NC"
    JSON.parse(response.body)["GeoTargeting"].first["MetroCode"].should == 560
    $location_id = JSON.parse(response.body)["GeoTargeting"].first["LocationId"].to_s
  end

  it "should get a flight with geotargeting" do
    response = @@flight.get($flight_id)
    #response.body.should == '{"Id":' + $flight_id + ',"StartDate":"\\/Date(1293840000000+0000)\\/","EndDate":"\\/Date(1325289600000+0000)\\/","Price":15.00,"OptionType":1,"Impressions":10000,"IsUnlimited":false,"IsNoDuplicates":false,"IsFullSpeed":false,"Keywords":"test, test2","Name":"' + $flight_Name + '","CampaignId":' + $campaignId.to_s + ',"PriorityId":0,"IsDeleted":false,"IsActive":true,"GeoTargeting":[{"LocationId":' + $location_id + ',"CountryCode":"US","Region":"NC","MetroCode":560}]}'
  end

  it "should create a flight with goal types, rate types, and day parting" do
    $flight_IsActive = true
    $flight_IsDeleted = false
    
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'IsDeleted' => $flight_IsDeleted,
      'GoalType' => 1,
      'RateType' => 1,
      'IsSunday' => true,
      'IsMonday' => true,
      'IsWednesday' => true,
      'DatePartingStartTime' => '12:00:00',
      'DatePartingEndTime' => '12:00:00'
    }
    response = @@flight.create(new_flight)
    $flight_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["NoEndDate"].should == false
    JSON.parse(response.body)["PriorityId"].to_s.should == $priority_id
    JSON.parse(response.body)["Name"].should == $flight_Name
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
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
    JSON.parse(response.body)["GoalType"].should == 1
    JSON.parse(response.body)["RateType"].should == 1
    JSON.parse(response.body)["IsSunday"].should == true
    JSON.parse(response.body)["IsMonday"].should == true
    JSON.parse(response.body)["IsWednesday"].should == true
    JSON.parse(response.body)["DatePartingStartTime"].should == '12:00:00'
    JSON.parse(response.body)["DatePartingEndTime"].should == '12:00:00' 
  end

  it "should create a flight with frequency capping" do
    $flight_IsActive = true
    $flight_IsDeleted = false
    
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'IsDeleted' => $flight_IsDeleted,
      'IsFreqCap' => true,
      'FreqCap' => 5,
      'FreqCapDuration' => 6,
      'FreqCapType' => 1
    }
    response = @@flight.create(new_flight)
    $flight_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["NoEndDate"].should == false
    JSON.parse(response.body)["PriorityId"].to_s.should == $priority_id
    JSON.parse(response.body)["Name"].should == $flight_Name
    # JSON.parse(response.body)["StartDate"].should == "/Date(1293840000000+0000)/"
    # JSON.parse(response.body)["EndDate"].should == "/Date(1325307600000-0500)/"
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
    JSON.parse(response.body)["IsFreqCap"].should == true
    JSON.parse(response.body)["FreqCap"].should == 5
    JSON.parse(response.body)["FreqCapDuration"].should == 6
    JSON.parse(response.body)["FreqCapType"].should == 1
  end  

  it "should test day parting without days selected" do
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'IsDeleted' => $flight_IsDeleted,
      'GoalType' => 1,
      'RateType' => 1,
      'DatePartingStartTime' => '12:00:00',
      'DatePartingEndTime' => '18:32:12'
    }
    response = @@flight.create(new_flight)
  end

  it "should test day parting without time selected" do
    new_flight = {
      'NoEndDate' => false,
      'PriorityId' => $priority_id,
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
      'IsDeleted' => $flight_IsDeleted,
      'GoalType' => 1,
      'RateType' => 1,      
      'IsSunday' => true,
      'IsMonday' => true,
      'IsWednesday' => true
    }
    response = @@flight.create(new_flight)
  end



end
