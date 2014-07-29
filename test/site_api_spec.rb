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
    expect($site_title).to eq(site[:title])
    expect(@site_url).to eq(site[:url])
    $site_pub_id = site[:publisher_account_id].to_s
  end

  it "should list a specific site" do
    site = @client.sites.get($site_id)
    expect(site[:id]).to eq($site_id.to_i)
    expect(site[:title]).to eq($site_title)
    expect(site[:url]).to eq(@site_url)
    expect(site[:publisher_account_id]).to eq($site_pub_id.to_i)
  end

  it "should update a site" do
    $site_title = 'Test Site ' + rand(1000000).to_s
    site = @client.sites.update(:id => $site_id,
                                    :title => $site_title + "test",
                                    :url => @site_url + "test")
    $site_id = site[:id].to_s
    expect($site_title + "test").to eq(site[:title])
    expect(@site_url + "test").to eq(site[:url])
    $site_pub_id = site[:publisher_account_id].to_s
  end

  it "should list all sites" do
    result = @client.sites.list
    expect(result.length).to be > 0
    expect(result[:items].last[:id].to_s).to eq($site_id)
    expect(result[:items].last[:title]).to eq($site_title + "test")
    expect(result[:items].last[:url]).to eq(@site_url + "test")
    expect(result[:items].last[:publisher_account_id].to_s).to eq($site_pub_id)
  end

  it "should delete a new site" do
    response = @client.sites.delete($site_id)
    expect(response.body).to eq('"Successfully deleted."')
  end

  it "should not list deleted sites" do
    result = @client.sites.list
    result[:items].each do |site|
      expect(site[:id].to_s).not_to eq($site_id)
    end
  end

end
