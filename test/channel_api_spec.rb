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
    $channel_title.should == channel[:title]
    $channel_commission.to_f.should == channel[:commission]
    $channel_engine.should == channel[:engine]
    $channel_keywords.should == channel[:keywords]
    $channel_cpm.to_f.should == channel[:cpm]
    $channel_ad_types.should == channel[:ad_types]
  end

  it "should list a specific channel" do
    channel = @channels.get($channel_id)
    $channel_title.should == channel[:title]
    $channel_commission.to_f.should == channel[:commission]
    $channel_engine.should == channel[:engine]
    $channel_keywords.should == channel[:keywords]
    $channel_cpm.to_f.should == channel[:cpm]
    $channel_ad_types.should == channel[:ad_types]
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

    $u_channel_title.should == channel[:title]
    $u_channel_commission.should == channel[:commission].to_s
    $u_channel_engine.should == channel[:engine]
    $u_channel_keywords.should == channel[:keywords]
    $u_channel_CPM.to_f.should == channel[:cpm]
    $u_channel_AdTypes.should == channel[:ad_types]
  end

  it "should list all channels" do
    result = @channels.list
    result.length.should > 0
    last_channel = result[:items].last
    last_channel[:id].to_s.should == $channel_id
    last_channel[:title].should == $u_channel_title
    last_channel[:commission].should == $u_channel_commission.to_f
    last_channel[:engine].should == $u_channel_engine
    last_channel[:keywords].should == $u_channel_keywords
    last_channel[:cpm].should == $u_channel_CPM.to_f
    last_channel[:ad_types].should == $u_channel_AdTypes
  end

  it "should delete a new channel" do
    response = @channels.delete($channel_id)
    response.body.should == '"Successfully deleted"'
  end

end
