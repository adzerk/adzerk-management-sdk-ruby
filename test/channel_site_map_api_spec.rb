require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Channel Site Map API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @csm = client.channel_site_maps
    @sites = client.sites
    @channels = client.channels
    channel = @channels.create(:title => 'Test Channel ' + rand(1000000).to_s,
                               :commission => '0.0',
                               :engine => 'CPM',
                               :keywords => 'test',
                               'CPM' => '10.00',
                               :ad_types =>  [1,2,3,4])
    @channel_id = channel[:id]
    new_site = {
     :title => 'Test Site ' + rand(1000000).to_s,
     :url => 'http://www.adzerk.com'
    }
    site = @sites.create(new_site)
    @site_id = site[:id]
  end

  it "should create a new map" do
    new_map = {
     :site_id => @site_id,
     :channel_id => @channel_id,
     :priority => 10
    }
    channel_site_map = @csm.create(new_map)
    channel_site_map[:site_id].should eq(@site_id)
    channel_site_map[:channel_id].should eq(@channel_id)
    channel_site_map[:priority].should eq(10)
  end

  it "should retrieve a list of sites in a channel" do
    sites = @csm.sites_in_channel(@channel_id)
    sites[:site_ids].should include(@site_id)
  end

  it "should retrieve a list of channels in a site" do
    channels = @csm.channels_in_site(@site_id)
    channels[:channel_ids].should include(@channel_id)
  end

  it "should list a specific map" do
    channel_site_map = @csm.get(@channel_id, @site_id)
    channel_site_map[:site_id].should eq(@site_id)
    channel_site_map[:channel_id].should eq(@channel_id)
    channel_site_map[:priority].should eq(10)
  end

  it "should update a map" do
    u_map = {
     :site_id => @site_id,
     :channel_id => @channel_id,
     :priority => 200
    }
    channel_map = @csm.update(u_map)
    channel_map[:priority].should eq(200)
  end

  # it "should list all maps for network" do
  #   channel_maps = @csm.list
  #   channel_maps[:items].last[:site_id].should eq(@site_id)
  # end

  it "should delete a new maps" do
    response = @csm.delete(@channel_id, @site_id)
    response.body.should == '"Successfully deleted."'
  end

end
