require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Channel API" do

  before do
    @channel_url = 'http://www.adzerk.com'
    @channels = Adzerk::Client.new(API_KEY).channels
  end

  it "should create a new channel" do
    $channel_title = 'Test Channel ' + rand(1000000).to_s
    $channel_commission = '0.00'
    $channel_engine = 'CPM'
    $channel_keywords = 'test, another test'
    $channel_cpm = '10.00'
    $channel_ad_types = [1,2,3,4,5]
    channel = @channels.create(:title => $channel_title,
                               :commission => $channel_commission,
                               :engine => $channel_engine,
                               :keywords => $channel_keywords,
                               :ad_types => $channel_ad_types,
                               'CPM' =>  $channel_cpm)
    $channel_id = channel[:id].to_s
    expect($channel_title).to eq(channel[:title])
    expect($channel_commission.to_f).to eq(channel[:commission])
    expect($channel_engine).to eq(channel[:engine])
    expect($channel_keywords).to eq(channel[:keywords])
    expect($channel_cpm.to_f).to eq(channel[:cpm])
    expect($channel_ad_types).to eq(channel[:ad_types])
  end

  it "should list a specific channel" do
    channel = @channels.get($channel_id)
    expect($channel_title).to eq(channel[:title])
    expect($channel_commission.to_f).to eq(channel[:commission])
    expect($channel_engine).to eq(channel[:engine])
    expect($channel_keywords).to eq(channel[:keywords])
    expect($channel_cpm.to_f).to eq(channel[:cpm])
    expect($channel_ad_types).to eq(channel[:ad_types])
  end

  it "should get priorities for channel" do
    count = @channels.get_priorities($channel_id)
    expect(count.length).to be > 0
  end

  it "should update a channel" do
    $u_channel_title = 'Test Channel ' + rand(1000000).to_s + 'test'
    $u_channel_commission = '1.0'
    $u_channel_engine = 'CPI'
    $u_channel_keywords = 'another test'
    $u_channel_CPM = '0'
    $u_channel_AdTypes = [4,5,6,7,8]

    channel = @channels.
      update(:id => $channel_id,
             :title => $u_channel_title,
             :commission => $u_channel_commission,
             :engine => $u_channel_engine,
             :keywords => $u_channel_keywords,
             :ad_types => $u_channel_AdTypes,
             'CPM' => $u_channel_CPM)

    expect($u_channel_title).to eq(channel[:title])
    expect($u_channel_commission).to eq(channel[:commission].to_s)
    expect($u_channel_engine).to eq(channel[:engine])
    expect($u_channel_keywords).to eq(channel[:keywords])
    expect($u_channel_CPM.to_f).to eq(channel[:cpm])
    expect($u_channel_AdTypes).to eq(channel[:ad_types])
  end

  it "should list all channels" do
    result = @channels.list
    expect(result.length).to be > 0
    last_channel = result[:items].last
    expect(last_channel[:id].to_s).to eq($channel_id)
    expect(last_channel[:title]).to eq($u_channel_title)
    expect(last_channel[:commission]).to eq($u_channel_commission.to_f)
    expect(last_channel[:engine]).to eq($u_channel_engine)
    expect(last_channel[:keywords]).to eq($u_channel_keywords)
    expect(last_channel[:cpm]).to eq($u_channel_CPM.to_f)
    expect(last_channel[:ad_types]).to match_array($u_channel_AdTypes)
  end

  it "should delete a new channel" do
    response = @channels.delete($channel_id)
    expect(response.body).to eq('"Successfully deleted."')
  end

  it "should get individual deleted channel" do
    channel = @channels.get $channel_id
    expect(channel[:is_deleted]).to eq(true)
  end

  it "should not update deleted channels" do
    updated_channel = {
      :id => $channel_id,
      :title => $u_channel_title + "test",
      :commission => $u_channel_commission,
      :engine => $u_channel_engine,
      :keywords => $u_channel_keywords,
      'CPM' => $u_channel_CPM,
      :ad_types => $u_channel_AdTypes
    }
    expect { @channels.update(updated_channel) }.to raise_error "This channel has been deleted"
  end

end
