require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Creative API" do
  
  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @creatives = client.creatives
    @advertiser_id = client.advertisers.create(:title => "Test")[:id]
  end
  
  it "should create a creative using old api spec" do
    new_creative = {
      :title => 'Test Creative Old API',
      :image_name => "",
      :url => "http://adzerk.com",
      :body => "Test Body",
      :advertiser_id => @advertiser_id,
      :ad_type_id => 18,
      :is_active => true,
      :alt => 'test alt',
      :is_deleted => false,
      :is_sync => false 
    }
    creative_path = File.expand_path(File.dirname(__FILE__) + '/' + '250x250.gif')
    creative = @creatives.create(new_creative, creative_path)
    $creative_id = creative[:id].to_s
    creative[:title].should eq('Test Creative Old API')
    creative[:url].should eq("http://adzerk.com")
    creative[:body].should eq("Test Body")
    creative[:advertiser_id].should eq(@advertiser_id)
    creative[:ad_type_id].should eq(18)
    creative[:is_active].should eq(true)
    creative[:alt].should eq('test alt')
    creative[:is_deleted].should eq(false)
    creative[:is_sync].should eq(false)
  end

  it "should create a creative using new api fields" do
    new_creative = {
      :title => "Creative with the new API",
      :image_name => "",
      :url => "http://adzerk.com",
      :body => "Test Body",
      :advertiser_id => @advertiser_id,
      :ad_type_id => 18,
      :is_active => true,
      :alt => "alt text",
      :is_deleted => false, 
      :is_sync => true,
      'isHTMLJS' => true,
      :script_body => "<html></html>"
    }
    creative = @creatives.create(new_creative)
    $creative_id = creative[:id].to_s
    creative[:title].should eq('Creative with the new API')
    creative[:url].should eq("http://adzerk.com")
    creative[:body].should eq("Test Body")
    creative[:advertiser_id].should eq(@advertiser_id)
    creative[:ad_type_id].should eq(18)
    creative[:is_active].should eq(true)
    creative[:alt].should eq('alt text')
    creative[:is_deleted].should eq(false)
    creative[:is_sync].should eq(false)
  end

  it "should get a specific creative" do
    creative = @creatives.get($creative_id)
    creative[:title].should eq('Creative with the new API')
    creative[:url].should eq("http://adzerk.com")
    creative[:body].should eq("Test Body")
    creative[:advertiser_id].should eq(@advertiser_id)
    creative[:ad_type_id].should eq(18)
    creative[:is_active].should eq(true)
    creative[:alt].should eq('alt text')
    creative[:is_deleted].should eq(false)
    creative[:is_sync].should eq(false)
  end

  it "should update a specific creative" do
    update_creative = {
      :id => $creative_id.to_i,
      :title => "Updated Title",
      :url => 'http://www.google.com',
      :body => 'new body',
      :advertiser_id => @advertiser_id,
      :ad_type_id => 18,
      :is_active => true,
      :alt => 'new alt text',
      :is_deleted => false,
      :is_sync => false
    }
    creative = @creatives.update(update_creative)
    creative[:title].should eq('Updated Title')
    creative[:url].should eq('http://www.google.com')
    creative[:body].should eq('new body')
  end


  it "should list all creatives for an advertiser" do
    response = @creatives.list(@advertiser_id)
    creative = response[:items].last
    creative[:url].should eq('http://www.google.com')
    creative[:body].should eq('new body')
  end

  it "should delete the creatives after creating it" do
    response = @creatives.delete($creative_id)
    response.body.should == '"Successfully deleted"'
  end

end
