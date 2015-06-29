require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

$channel_id = nil
$ad_type_network_id = nil
$ad_type_channel_id = nil

describe "Ad Type API" do

  before(:each) do
    @client = Adzerk::Client.new(API_KEY)
  end

  it "should list ad types for network" do
    result = @client.ad_types.list
    expect(result.length).to be > 0
    expect(result[:items].last[:id].to_s).to_not eq(nil)
    expect(result[:items].last[:width]).to_not eq(nil)
    expect(result[:items].last[:height]).to_not eq(nil)
  end

  it "should list ad types for channel" do
    $channel_id = @client.channels.list[:items].last[:id].to_s
    result = @client.ad_types.list($channel_id)
    expect(result[:items].last[:id].to_s).to_not eq(nil)
    expect(result[:items].last[:width]).to_not eq(nil)
    expect(result[:items].last[:height]).to_not eq(nil)
  end

  it "should create ad type for network" do
    result = @client.ad_types.create({:width => 1000, :height => 2000})
    $ad_type_network_id = result[:id].to_s
    expect(result[:id].to_s).to_not eq(nil)
    expect(result[:width].to_s).to eq("1000")
    expect(result[:height].to_s).to eq("2000")
    expect(result[:name].to_s).to_not eq(nil)
  end

  it "should create ad type for channel" do
    result = @client.ad_types.create({:width => 3000, :height => 4000}, $channel_id)
    $ad_type_network_id = result[:id].to_s
    expect(result[:id].to_s).to_not eq(nil)
    expect(result[:width].to_s).to eq("3000")
    expect(result[:height].to_s).to eq("4000")
    expect(result[:name].to_s).to_not eq(nil)
  end

  it "should delete ad type for network" do
    @client.ad_types.delete($ad_type_network_id)
  end

  it "should delete ad type for channel" do
    $ad_type_channel_id = @client.channels.list[:items].last[:id].to_s
    @client.ad_types.delete($ad_type_channel_id, $channel_id)
  end
end
