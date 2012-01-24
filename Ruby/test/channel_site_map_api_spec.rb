require 'spec_helper'

describe "Channel Site Map API" do
  
  $site_url = 'http://www.adzerk.com'
  @@csm = $adzerk::ChannelSiteMap.new
  @@channel = $adzerk::Channel.new
  @@site = $adzerk::Site.new

  before(:all) do
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

    new_site = {
     'Title' => 'Test Site ' + rand(1000000).to_s,
     'Url' => 'http://www.adzerk.com'
    }
    response = @@site.create(new_site)
    $siteId = JSON.parse(response.body)["Id"]
  end
  
  it "should create a new map" do
    new_map = {
     'SiteId' => $siteId,
     'ChannelId' => $channelId,
     'Priority' => 10
    }
    response = @@csm.create(new_map)
    JSON.parse(response.body)["SiteId"].should == $siteId
    JSON.parse(response.body)["ChannelId"].should == $channelId 
    JSON.parse(response.body)["Priority"].should == 10
  end

  it "should retrieve a list of sites in a channel" do
    response = @@csm.sitesInChannel($channelId)
    true.should ==  response.body.scan(/#{$siteId}/).length >= 1
  end

  it "should retrieve a list of channels in a site" do
    response = @@csm.channelsInSite($siteId)
    true.should ==  response.body.scan(/#{$channelId}/).length >= 1
  end
  
  it "should list a specific map" do
    response = @@csm.get($channelId, $siteId)
    response.body.should == '{"SiteId":' + $siteId.to_s + ',"ChannelId":' + $channelId.to_s + ',"FixedPaymentAmount":0' + ',"Priority":' + '10}'
  end

  it "should update a map" do
    u_map = {
     'SiteId' => $siteId,
     'ChannelId' => $channelId,
     'Priority' => 200
    }
    response = @@csm.update(u_map)
    JSON.parse(response.body)["SiteId"].should == $siteId
    JSON.parse(response.body)["ChannelId"].should == $channelId 
    JSON.parse(response.body)["Priority"].should == 200
  end

  it "should list all maps for network" do
    result = @@csm.list()
    result.length.should > 0
    result["Items"].last["SiteId"].should == $siteId
    result["Items"].last["ChannelId"].should == $channelId
    result["Items"].last["Priority"].should == 200 
  end

  it "should delete a new maps" do
    response = @@csm.delete($channelId, $siteId)
    response.body.should == 'OK'
  end

  it "should not list deleted maps" do
    result = @@csm.list()
    result["Items"].each do |r|
      r["SiteId"].should_not == $siteId and 
      r["ChannelId"].should_not == $channelId
    end
  end

  it "should not get individual deleted maps" do
    response = @@csm.get($channelId, $siteId)
    response.body.should == '{"SiteId":0,"ChannelId":0,"Priority":0}'
  end

  it "should not update deleted maps" do
    u_map = {
     'SiteId' => $siteId,
     'ChannelId' => $channelId,
     'Priority' => 300
    }
    response = @@csm.update(u_map)
    response.body.should == '{"SiteId":0,"ChannelId":0,"Priority":0}'
  end

  it "should not create if the site is in a different network" do
    new_map = {
     'SiteId' => 1,
     'ChannelId' => $channelId,
     'Priority' => 10
    }
    response = @@csm.create(new_map)
    true.should == response.body.scan(/This site is not part of your network/).length > 1
  end

  it "should not create if the channel is in a different netowork" do
    new_map = {
     'SiteId' => $siteId,
     'ChannelId' => 1,
     'Priority' => 10
    }
    response = @@csm.create(new_map)
    true.should == response.body.scan(/This channel is not part of your network/).length > 1
  end

end