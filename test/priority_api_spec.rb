require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Priority API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @channels = client.channels
    channel = @channels.
      create(:title => 'Test Channel ' + rand(1000000).to_s,
             :commission => '0',
             :engine => 'CPM',
             :keywords => 'test',
             'CPM' => '10.00',
             :ad_types => [1,2,3,4])
    $channel_id = channel[:id].to_s
    @priorities = client.priorities
  end

  after(:all) do
    @channels.delete($channel_id)
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
    expect($priority_name).to eq(priority[:name])
    expect($priority_channel_id.to_f).to eq(priority[:channel_id])
    expect($priority_weight).to eq(priority[:weight])
    expect($priority_is_deleted).to eq(priority[:is_deleted])
    expect(priority[:selection_algorithm]).to eq(0) # default (Lottery)
  end

  it "should list a specific priority" do
    priority = @priorities.get($priority_id)
    expect($priority_name).to eq(priority[:name])
    expect($priority_channel_id.to_f).to eq(priority[:channel_id])
    expect($priority_weight).to eq(priority[:weight])
    expect($priority_is_deleted).to eq(priority[:is_deleted])
    expect(priority[:selection_algorithm]).to eq(0)
  end

  it "should update a priority" do
    priority = @priorities.
      update(:id => $priority_id,
             :name => $priority_name,
             :channel_id => $priority_channel_id,
             :weight => 2,
             :is_deleted => $priority_is_deleted)

    expect($priority_name).to eq(priority[:name])
    expect($priority_channel_id.to_f).to eq(priority[:channel_id])
    expect(priority[:weight]).to eq(2)
    expect($priority_is_deleted).to eq(priority[:is_deleted])
    expect(priority[:selection_algorithm]).to eq(0)
  end

  it "should not allow selection algorithm to be updated" do
    expect { @priorities.update(selection_algorithm: 1) }.to raise_error JSON::ParserError
  end

  it "should list all priorities" do
    result = @priorities.list
    expect(result.length).to be > 0
    priority = result[:items].last
    priority[:id].to_s == $priority_id 
    expect($priority_name).to eq(priority[:name])
    expect($priority_channel_id.to_f).to eq(priority[:channel_id])
    expect(priority[:weight]).to eq(2)
    expect($priority_is_deleted).to eq(priority[:is_deleted])
    expect(priority[:selection_algorithm]).to eq(0)
  end

  it "should delete a new priority" do
    response = @priorities.delete($priority_id)
    expect(response.body).to eq('"Successfully deleted"')
  end
end

