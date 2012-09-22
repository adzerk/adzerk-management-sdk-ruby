require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Priority API" do
  
  $priority_url = 'http://www.adzerk.com'
  @@channel = $adzerk::Channel.new
  @@priority = $adzerk::Priority.new

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
    $channelId = JSON.parse(response.body)["Id"].to_s
  end

  it "should create a new priority" do
    $priority_name = 'Test priority ' + rand(1000000).to_s
    $priority_channelId = $channelId
    $priority_weight = 1
    $priority_isDeleted = false

    new_priority = {
      'Name' => $priority_name,
      'ChannelId' => $priority_channelId,
      'Weight' => $priority_weight,
      'IsDeleted' => $priority_isDeleted
    }
  
    response = @@priority.create(new_priority)
    $priority_id = JSON.parse(response.body)["Id"].to_s
    $priority_name.should == JSON.parse(response.body)["Name"]
    $priority_channelId.to_f.should == JSON.parse(response.body)["ChannelId"]
    $priority_weight.should == JSON.parse(response.body)["Weight"]
    $priority_isDeleted.should == JSON.parse(response.body)["IsDeleted"]
  end
  
  it "should list a specific priority" do
    response = @@priority.get($priority_id)
    response.body.should == '{"Id":' + $priority_id + ',"Name":"' + $priority_name + '","ChannelId":' + $priority_channelId.to_s + ',"Weight":' + $priority_weight.to_s + ',"IsDeleted":' + $priority_isDeleted.to_s + '}'
  end
  
  it "should update a priority" do
    new_priority = {
      'Id' => $priority_id,
      'Name' => $priority_name,
      'ChannelId' => $priority_channelId,
      'Weight' => $priority_weight,
      'IsDeleted' => $priority_isDeleted
    }
  
    response = @@priority.update(new_priority)
    $priority_name.should == JSON.parse(response.body)["Name"]
    $priority_channelId.to_f.should == JSON.parse(response.body)["ChannelId"]
    $priority_weight.should == JSON.parse(response.body)["Weight"]
    $priority_isDeleted.should == JSON.parse(response.body)["IsDeleted"]
  end
  
  it "should list all priorities" do
    result = @@priority.list()
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $priority_id 
    result["Items"].last["Name"].should == $priority_name 
    result["Items"].last["ChannelId"].to_s.should == $priority_channelId 
    result["Items"].last["Weight"].should == $priority_weight 
    result["Items"].last["IsDeleted"].should == $priority_isDeleted 
  end
  
  it "should delete a new priority" do
    response = @@priority.delete($priority_id)
    response.body.should == 'OK'
  end
  
  it "should not list deleted priorities" do
    result = @@priority.list()
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $priority_id  
    end
  end
  
  it "should not get individual deleted priority" do
    response = @@priority.get $priority_id
    response.body.should == '{"Id":0,"ChannelId":0,"Weight":0,"IsDeleted":false}'
  end
  
  it "should not update deleted priorities" do
    u_priority = {
      'Id' => $priority_id,
      'Name' => $priority_name,
      'ChannelId' => $priority_channelId,
      'Weight' => $priority_weight,
      'IsDeleted' => $priority_isDeleted,
    }
  
    response = @@priority.update(u_priority)
    response.body.should == '{"Id":0,"ChannelId":0,"Weight":0,"IsDeleted":false}'
  end

end

