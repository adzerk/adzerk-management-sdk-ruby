require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Site API" do
  
  before(:each) do
    @site_url = 'http://www.adzerk.com'
    @client = Adzerk::Client.new(API_KEY)
  end
  
  it "should create a new site" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    new_site = {
     'Title' => $site_title,
     'Url' => @site_url
    }
    response = @client.sites.create(new_site)
    $site_id = JSON.parse(response.body)["Id"].to_s
    $site_title.should == JSON.parse(response.body)["Title"]
    @site_url.should == JSON.parse(response.body)["Url"]
    $site_pub_id = JSON.parse(response.body)["PublisherAccountId"].to_s
  end
  
  it "should list a specific site" do
    response = @client.sites.get($site_id)
    response.body.should == '{"Id":' + $site_id + ',"Title":"' + $site_title + '","Url":"' + @site_url + '","PublisherAccountId":' + $site_pub_id + ',"IsDeleted":false}'
  end

  it "should update a site" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    updated_site = {
      'Id' => $site_id,
      'Title' => $site_title + "test",
      'Url' => @site_url + "test"
    }
    response = @client.sites.update(updated_site)
    $site_id = JSON.parse(response.body)["Id"].to_s
    ($site_title + "test").should == JSON.parse(response.body)["Title"]
    (@site_url + "test").should == JSON.parse(response.body)["Url"]
    $site_pub_id = JSON.parse(response.body)["PublisherAccountId"].to_s
  end

  it "should list all sites" do
    result = @client.sites.list
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $site_id
    result["Items"].last["Title"].should == $site_title + "test"
    result["Items"].last["Url"].should == @site_url + "test"
    result["Items"].last["PublisherAccountId"].to_s.should == $site_pub_id
  end

  it "should delete a new site" do
    response = @client.sites.delete($site_id)
    response.body.should == 'OK'
  end

  it "should not list deleted sites" do
    result = @client.sites.list
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $site_id
    end
  end

  it "should not get individual deleted sites" do
    response = @client.sites.get($site_id)
    response.body.should == '{"Id":0,"PublisherAccountId":0,"IsDeleted":false}'
  end

  it "should not update deleted sites" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    updated_site = {
      'Id' => $site_id,
      'Title' => $site_title,
      'Url' => @site_url
    }
    response = @client.sites.update(updated_site)
    response.body.should == '{"Id":0,"PublisherAccountId":0,"IsDeleted":false}'
  end

end
