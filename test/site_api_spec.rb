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
    site = @client.sites.create(:title => $site_title, :url => @site_url)
    $site_id = site[:id].to_s
    $site_title.should == site[:title]
    @site_url.should == site[:url]
    $site_pub_id = site[:publisher_account_id].to_s
  end

  it "should list a specific site" do
    site = @client.sites.get($site_id)
    site[:id].should eq($site_id.to_i)
    site[:title].should eq($site_title)
    site[:url].should eq(@site_url)
    site[:publisher_account_id].should eq($site_pub_id.to_i)
  end

  it "should update a site" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    response = @client.sites.update(:id => $site_id,
                                    :title => $site_title + "test",
                                    :url => @site_url + "test")
    $site_id = JSON.parse(response.body)["Id"].to_s
    ($site_title + "test").should == JSON.parse(response.body)["Title"]
    (@site_url + "test").should == JSON.parse(response.body)["Url"]
    $site_pub_id = JSON.parse(response.body)["PublisherAccountId"].to_s
  end

  it "should list all sites" do
    result = @client.sites.list
    result.length.should > 0
    result[:items].last[:id].to_s.should == $site_id
    result[:items].last[:title].should == $site_title + "test"
    result[:items].last[:url].should == @site_url + "test"
    result[:items].last[:publisher_account_id].to_s.should == $site_pub_id
  end

  it "should delete a new site" do
    response = @client.sites.delete($site_id)
    response.body.should == 'OK'
  end

  it "should not list deleted sites" do
    result = @client.sites.list
    result[:items].each do |site|
      site[:id].to_s.should_not == $site_id
    end
  end

  it "should not get individual deleted sites" do
    site = @client.sites.get($site_id)
    site[:id].should eq(0)
    site[:publisher_account_id].should eq(0)
    site[:is_deleted].should eq(false)
  end

  it "should not update deleted sites" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    response = @client.sites.update(:id => $site_id,
                                    :title => $site_title,
                                    :url => @site_url)
    response.body.should == '{"Id":0,"PublisherAccountId":0,"IsDeleted":false}'
  end

end
