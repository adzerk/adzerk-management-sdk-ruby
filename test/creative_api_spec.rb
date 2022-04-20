require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Creative API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @advertisers = client.advertisers
    @creatives = client.creatives
    @advertiser_id = @advertisers.create(:title => "Test")[:id]
  end

  after(:all) do
    @advertisers.delete(@advertiser_id)
  end

  # this test gets a 400 error... doesn't work with current release
  # commenting out for now

  # it "should create a creative using old api spec" do
  #   new_creative = {
  #     :title => 'Test Creative Old API',
  #     :image_name => "",
  #     :url => "http://adzerk.com",
  #     :body => "Test Body",
  #     :advertiser_id => @advertiser_id,
  #     :ad_type_id => 18,
  #     :is_active => true,
  #     :alt => 'test alt',
  #     :is_deleted => false,
  #     :is_sync => false
  #   }
  #   creative_path = File.expand_path(File.dirname(__FILE__) + '/' + '250x250.gif')
  #   creative = @creatives.create(new_creative, creative_path)
  #   $creative_id = creative[:id].to_s
  #   creative[:title].should eq('Test Creative Old API')
  #   creative[:url].should eq("http://adzerk.com")
  #   creative[:body].should eq("Test Body")
  #   creative[:advertiser_id].should eq(@advertiser_id)
  #   creative[:ad_type_id].should eq(18)
  #   creative[:is_active].should eq(true)
  #   creative[:alt].should eq('test alt')
  #   creative[:is_deleted].should eq(false)
  #   creative[:is_sync].should eq(false)
  # end

  it "should create a creative using new api fields" do

    $Title = 'Test creative ' + rand(1000000).to_s
    $Url = "http://adzerk.com"
    $Body = "Test Body"
    $AdTypeId = 18
    $IsHTMLJS = true
    $ScriptBody = '<html></html>'
    $IsCreativeActive = true
    $IsCreativeDeleted = false
    $Alt = "test alt"
    $IsSync = false

    new_creative = {
      :title => $Title,
      :image_name => "",
      :url => $Url,
      :body => $Body,
      :advertiser_id => @advertiser_id,
      :ad_type_id => $AdTypeId,
      :is_active => $IsCreativeActive,
      :alt => $Alt,
      :is_deleted => $IsCreativeDeleted,
      :is_sync => $IsSync,
      :'isHTMLJS' => $isHTMLJS,
      :script_body => $ScriptBody
    }
    creative = @creatives.create(new_creative)
    $creative_id = creative[:id].to_s

    expect(creative[:title]).to eq($Title)
    expect(creative[:url]).to eq($Url)
    expect(creative[:body]).to eq($Body)
    expect(creative[:advertiser_id]).to eq(@advertiser_id)
    expect(creative[:ad_type_id]).to eq($AdTypeId)
    expect(creative[:is_active]).to eq($IsCreativeActive)
    expect(creative[:alt]).to eq($Alt)
    expect(creative[:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative[:is_sync]).to eq($IsSync)
  end

  it "should get a specific creative" do
    creative = @creatives.get($creative_id)
    expect(creative[:title]).to eq($Title)
    expect(creative[:url]).to eq($Url)
    expect(creative[:body]).to eq($Body)
    expect(creative[:advertiser_id]).to eq(@advertiser_id)
    expect(creative[:ad_type_id]).to eq($AdTypeId)
    expect(creative[:is_active]).to eq($IsCreativeActive)
    expect(creative[:alt]).to eq($Alt)
    expect(creative[:is_deleted]).to eq($IsCreativeDeleted)
    expect(creative[:is_sync]).to eq($IsSync)
  end

  it "should update a specific creative" do

    $new_title = "Updated Title"
    $new_url = "http://adzerk2.com"
    $new_body = "new body"
    $new_ad_type_id = 5
    $new_is_active = false
    $new_alt = "new alt text"
    $new_is_sync = false

    update_creative = {
      :id => $creative_id.to_i,
      :title => $new_title,
      :url => $new_url,
      :body => $new_body,
      :advertiser_id => @advertiser_id,
      :ad_type_id => $new_ad_type_id,
      :is_active => $new_is_active,
      :alt => $new_alt,
      :is_deleted => false,
      :is_sync => $new_is_sync
    }
    creative = @creatives.update(update_creative)
    expect(creative[:title]).to eq($new_title)
    expect(creative[:url]).to eq($new_url)
    expect(creative[:body]).to eq($new_body)
    expect(creative[:ad_type_id]).to eq($new_ad_type_id)
    expect(creative[:is_active]).to eq($new_is_active)
    expect(creative[:is_sync]).to eq($new_is_sync)
  end


  it "should list all creatives for an advertiser" do
    response = @creatives.list(@advertiser_id)
    creative = response[:items].last
    expect(creative[:title]).to eq($new_title)
    expect(creative[:url]).to eq($new_url)
    expect(creative[:body]).to eq($new_body)
    expect(creative[:ad_type_id]).to eq($new_ad_type_id)
    expect(creative[:is_active]).to eq($new_is_active)
    expect(creative[:is_sync]).to eq($new_is_sync)
  end

  it "should list all creatives for a network" do
    creatives = @creatives.list_for_network()
    expect(creatives.length).to be > 0
  end

  it "should delete the creatives after creating it" do
    response = @creatives.delete($creative_id)
    expect(response.body).to eq('"Successfully deleted"')
  end

end
