require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Priority API" do
  
  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    channels = client.channels
    channel = channels.
      create(:title => 'Test Channel ' + rand(1000000).to_s,
             :commission => '0',
             :engine => 'CPM',
             :keywords => 'test',
             'CPM' => '10.00',
             :ad_types => [1,2,3,4])
    $channel_id = channel[:id].to_s
    @priorities = client.priorities
  end

  it "should create a new priority" do
    $priority_name = 'Test priority ' + rand(1000000).to_s
    $priority_channel_id = $channel_id
    $priority_weight = 1
    $priority_is_deleted = false

    priority = @priorities.create(:name => $priority_name,
                                  :channel_id => $priority_channel_id,
                                  :weight => $priority_weight,
                                  :is_deleted => $priority_is_deleted)
    $priority_id = priority[:id].to_s
    $priority_name.should == priority[:name]
    $priority_channel_id.to_f.should == priority[:channel_id]
    $priority_weight.should == priority[:weight]
    $priority_is_deleted.should == priority[:is_deleted]
  end
  
  it "should list a specific priority" do
    priority = @priorities.get($priority_id)
    $priority_name.should == priority[:name]
    $priority_channel_id.to_f.should == priority[:channel_id]
    $priority_weight.should == priority[:weight]
    $priority_is_deleted.should == priority[:is_deleted]
    priority = @priorities.get($priority_id)
  end
  
  it "should update a priority" do
    priority = @priorities.
      update(:id => $priority_id,
             :name => $priority_name,
             :channel_id => $priority_channel_id,
             :weight => 2,
             :is_deleted => $priority_is_deleted)
  
    $priority_name.should == priority[:name]
    $priority_channel_id.to_f.should == priority[:channel_id]
    priority[:weight].should == 2
    $priority_is_deleted.should == priority[:is_deleted]
  end
  
  it "should list all priorities" do
    result = @priorities.list
    result.length.should > 0
    priority = result[:items].last
    priority[:id].to_s == $priority_id 
    $priority_name.should == priority[:name]
    $priority_channel_id.to_f.should == priority[:channel_id]
    priority[:weight].should == 2
    $priority_is_deleted.should == priority[:is_deleted]
  end
  
  it "should delete a new priority" do
    response = @priorities.delete($priority_id)
    response.body.should == '"Successfully deleted"'
  end
end

