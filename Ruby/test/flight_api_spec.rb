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
    $flight_IsActive = false
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
    # $flight_id = JSON.parse(response.body)["Id"].to_s
    # $flight_Name.should == JSON.parse(response.body)["Name"]
    # #$flight_StartDate.should == JSON.parse(response.body)["StartDate"]
    # #$flight_EndDate.should == JSON.parse(response.body)["EndDate"]
    # $flight_IsActive.should == JSON.parse(response.body)["IsActive"]
    # $flight_Price.to_f.should == JSON.parse(response.body)["Price"]
    # $flight_BrandId.should == JSON.parse(response.body)["BrandId"]
    # JSON.parse(response.body)["IsDeleted"].should == false
    # $flight_Flights.should == JSON.parse(response.body)["Flights"]
  end
  
  
  # it "should list a specific flight" do
  #   response = @@flight.get($flight_id)
  #   response.body.should == '{"Id":' + $flight_id + ',"Name":"' + $flight_Name + '","StartDate":"\/Date(1293858000000-0500)\/","EndDate":"\/Date(1325307600000-0500)\/","IsActive":false,"Price":' + $flight_Price + ',"BrandId":' + $flight_BrandId.to_s + ',"IsDeleted":false}'
  # end
  # 
  # it "should update a flight" do
  #   $u_flight_title = 'Test flight ' + rand(1000000).to_s + 'test'
  #   $u_flight_commission = '1'
  #   $u_flight_engine = 'CPI'
  #   $u_flight_keywords = 'another test'
  #   $u_flight_CPM = '0'
  #   $u_flight_AdTypes = [4,5,6,7,8]
  #   
  #   updated_flight = {
  #     'Id' => $flight_id,
  #     'Title' => $u_flight_title,
  #     'Commission' => $u_flight_commission,
  #     'Engine' => $u_flight_engine,
  #     'Keywords' => $u_flight_keywords,
  #     'CPM' => $u_flight_CPM,
  #     'AdTypes' => $u_flight_AdTypes
  #   }
  # 
  #   response = @@flight.update(updated_flight)
  #   $flight_id = JSON.parse(response.body)["Id"].to_s
  #   $u_flight_title.should == JSON.parse(response.body)["Title"]
  #   $u_flight_commission.to_f.should == JSON.parse(response.body)["Commission"]
  #   $u_flight_engine.should == JSON.parse(response.body)["Engine"]
  #   $u_flight_keywords.should == JSON.parse(response.body)["Keywords"]
  #   $u_flight_CPM.to_f.should == JSON.parse(response.body)["CPM"]
  #   $u_flight_AdTypes.should == JSON.parse(response.body)["AdTypes"]
  # end
  
  it "should list all flights" do
    result = @@flight.list()
    result.length.should > 0
    puts result.to_json
    # result["Items"].last["Id"].to_s.should == $flight_id
    # result["Items"].last["Title"].should == $u_flight_title
    # result["Items"].last["Commission"].should == $u_flight_commission.to_f
    # result["Items"].last["Engine"].should == $u_flight_engine
    # result["Items"].last["Keywords"].should == $u_flight_keywords
    # result["Items"].last["CPM"].to_s.should == $u_flight_CPM.to_f.to_s
    # result["Items"].last["AdTypes"].should == $u_flight_AdTypes
  end
  
  # it "should delete a new flight" do
  #   response = @@flight.delete($flight_id)
  #   response.body.should == 'OK'
  # end
  # 
  # it "should not list deleted flights" do
  #   result = @@flight.list()
  #   result["Items"].each do |r|
  #     r["Id"].to_s.should_not == $flight_id
  #   end
  # end
  # 
  # it "should not get individual deleted flight" do
  #   response = @@flight.get($flight_id)
  #   response.body.should == '{"Id":0,"Commission":0,"CPM":0}'
  # end
  # 
  # it "should not update deleted flights" do
  #   updated_flight = {
  #     'Id' => $flight_id,
  #     'Title' => $u_flight_title + "test",
  #     'Commission' => $u_flight_commission,
  #     'Engine' => $u_flight_engine,
  #     'Keywords' => $u_flight_keywords,
  #     'CPM' => $u_flight_CPM,
  #     'AdTypes' => $u_flight_AdTypes
  #   }
  #   response = @@flight.update(updated_flight)
  #   response.body.should == '{"Id":0,"Commission":0,"CPM":0}'
  # end
  
  it "should not be able to edit a brand you don't have access to" do
    
  end
  
  
  # 
  # 
  # it "should not update the id of a flight" do
  #   # can't update id of another site because the site id in the 
  #   # route doesn't matter. Taken from the json passed in.
  # end
  # 
  # it "should not add a flight to a different network" do
  #   # since I removed the network id from the route, it cannot 
  #   # be changed. Depends solely on the on the api key.
  # end
  # 
  # it "should not update a flight on a different network" do
  #   # since I removed the network id from the route, it cannot 
  #   # be changed. Depends solely on the on the api key.
  # end
  # 
  # it "should not get a flight on a different network" do
  #   # since I removed the network id from the route, it cannot 
  #   # be changed. Depends solely on the on the api key.
  # end
  # 
  # it "should not list flights a different network" do
  #   # since I removed the network id from the route, it cannot 
  #   # be changed. Depends solely on the on the api key.
  # end
  # 
  # it "should not delete flights a different network" do
  #   # since I removed the network id from the route, it cannot 
  #   # be changed. Depends solely on the on the api key.
  # end  

end
