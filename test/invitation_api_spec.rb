require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Invitation API" do
  before do
    @client = Adzerk::Client.new(API_KEY)
    advertiser = @client.advertisers.create(:title => "Coca cola",
                                     :is_active => true,
                                     :is_deleted => false)
    site = @client.sites.create(:title => 'Adzerk', :url => 'http://www.adzerk.com')
    @advertiser_id = advertiser[:id].to_s
    @site_id = site[:id].to_s
  end

  it "should create a new publisher invitation" do
    response = @client.invitations.invite_publisher(:email => 'test@adzerk.com',
                                        :site_id => @site_id,
                                        :advertiser_id => @advertiser_id)
    expect(response.body).not_to eq("")
    expect(response.body.length).to be > 10
    expect(response.body.length).to be < 100
  end

  it "should create a new advertiser invitation" do
    response = @client.invitations.invite_advertiser(:email => 'test@adzerk.com',
                                                 :site_id => @site_id,
                                                 :advertiser_id => @advertiser_id)
    expect(response.body).not_to eq("")
    expect(response.body.length).to be > 10
    expect(response.body.length).to be < 100
  end

end
