require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Ad Type API" do

  before(:each) do
    @client = Adzerk::Client.new(API_KEY)
  end

  it "should list all ad_types" do
    result = @client.ad_types.list
    expect(result.length).to be > 0
    expect(result[:items].last[:id].to_s).to_not eq(nil)
    expect(result[:items].last[:width]).to_not eq(nil)
    expect(result[:items].last[:height]).to_not eq(nil)
  end
end
