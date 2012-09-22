require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Invitation API" do

  $invitation_url = 'http://www.adzerk.com/'
  @@invite = $adzerk::Invitation.new
  @@advertiser = $adzerk::Advertiser.new
  $email = "test+apitest@adzerk.com"
  
  before(:all) do
    site = $adzerk::Site.new
    site_url = "http://adzerk.com"
    site_title = 'Test Site ' + rand(1000000).to_s
    new_site = {
     'Title' => site_title,
     'Url' => site_url
    }
    response = site.create(new_site)
    $siteId = JSON.parse(response.body)["Id"].to_s
    new_advertiser = {
      'Title' => "Test"
    }
    response = @@advertiser.create(new_advertiser)
    $advertiserId = JSON.parse(response.body)["Id"].to_s
  end

  it "should create a new publisher invitation" do

    invitation = {
      'Email' => $email,
      'SiteId' => $siteId,
      'AdvertiserId' => $advertiserId
    }
  
    response = @@invite.invite_publisher(invitation)
    response.body.should_not == ""
    response.body.length.should > 10
    response.body.length.should < 100
  end
  
  it "should create a new advertiser invitation" do

    invitation = {
      'Email' => $email,
      'SiteId' => $siteId,
      'AdvertiserId' => $advertiserId
    }
  
    response = @@invite.invite_advertiser(invitation)
    response.body.should_not == ""
    response.body.length.should > 10
    response.body.length.should < 100
  end
  
end
