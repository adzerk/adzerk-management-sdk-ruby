require 'spec_helper'

describe "Channel API" do
  
  $channel_url = 'http://www.adzerk.com'
  @@channel = $adzerk::Channel.new
  
  it "should create a new channel" do
    $channel_title = 'Test Channel ' + rand(1000000).to_s
    $channel_commission = '0'
    $channel_engine = 'CPM'
    $channel_keywords = 'test, another test'
    $channel_CPM = '10.00'
    $channel_AdTypes = [0,1,2,3,4]
    
    new_channel = {
      'Title' => $channel_title,
      'Commission' => $channel_commission,
      'Engine' => $channel_engine,
      'Keywords' => $channel_keywords,
      'CPM' => $channel_CPM,
      'AdTypes' => $channel_AdTypes
    }
  
    response = @@channel.create(new_channel)
    $channel_id = JSON.parse(response.body)["Id"].to_s
    $channel_title.should == JSON.parse(response.body)["Title"]
    $channel_commission.to_f.should == JSON.parse(response.body)["Commission"]
    $channel_engine.should == JSON.parse(response.body)["Engine"]
    $channel_keywords.should == JSON.parse(response.body)["Keywords"]
    $channel_CPM.to_f.should == JSON.parse(response.body)["CPM"]
    $channel_AdTypes.should == JSON.parse(response.body)["AdTypes"]
  end
  
  it "should list a specific channel" do
    response = @@channel.get($channel_id)
    response.body.should == '{"Id":' + $channel_id + ',"Title":"' + $channel_title + '","Commission":' + $channel_commission.to_s + ',"Engine":"' + $channel_engine + '","Keywords":"' + $channel_keywords + '","CPM":' + $channel_CPM + ',"AdTypes":' + $channel_AdTypes.to_json + ',"IsDeleted":false}'
  end
  
  it "should update a channel" do
    $u_channel_title = 'Test Channel ' + rand(1000000).to_s + 'test'
    $u_channel_commission = '1'
    $u_channel_engine = 'CPI'
    $u_channel_keywords = 'another test'
    $u_channel_CPM = '0'
    $u_channel_AdTypes = [4,5,6,7,8]
    
    updated_channel = {
      'Id' => $channel_id,
      'Title' => $u_channel_title,
      'Commission' => $u_channel_commission,
      'Engine' => $u_channel_engine,
      'Keywords' => $u_channel_keywords,
      'CPM' => $u_channel_CPM,
      'AdTypes' => $u_channel_AdTypes
    }
  
    response = @@channel.update(updated_channel)
    $channel_id = JSON.parse(response.body)["Id"].to_s
    $u_channel_title.should == JSON.parse(response.body)["Title"]
    $u_channel_commission.to_f.should == JSON.parse(response.body)["Commission"]
    $u_channel_engine.should == JSON.parse(response.body)["Engine"]
    $u_channel_keywords.should == JSON.parse(response.body)["Keywords"]
    $u_channel_CPM.to_f.should == JSON.parse(response.body)["CPM"]
    $u_channel_AdTypes.should == JSON.parse(response.body)["AdTypes"]
  end
  
  it "should list all channels" do
    result = @@channel.list()
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $channel_id
    result["Items"].last["Title"].should == $u_channel_title
    result["Items"].last["Commission"].should == $u_channel_commission.to_f
    result["Items"].last["Engine"].should == $u_channel_engine
    result["Items"].last["Keywords"].should == $u_channel_keywords
    result["Items"].last["CPM"].to_s.should == $u_channel_CPM.to_f.to_s
    result["Items"].last["AdTypes"].should == $u_channel_AdTypes
  end
  
  it "should delete a new channel" do
    response = @@channel.delete($channel_id)
    response.body.should == 'OK'
  end
  
  it "should not list deleted channels" do
    result = @@channel.list()
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $channel_id
    end
  end
  
  it "should not get individual deleted channel" do
    response = @@channel.get($channel_id)
    response.body.should == '{"Id":0,"Commission":0,"CPM":0,"IsDeleted":false}'
  end
  
  it "should not update deleted channels" do
    updated_channel = {
      'Id' => $channel_id,
      'Title' => $u_channel_title + "test",
      'Commission' => $u_channel_commission,
      'Engine' => $u_channel_engine,
      'Keywords' => $u_channel_keywords,
      'CPM' => $u_channel_CPM,
      'AdTypes' => $u_channel_AdTypes
    }
    response = @@channel.update(updated_channel)
    response.body.should == '{"Id":0,"Commission":0,"CPM":0,"IsDeleted":false}'
  end

end