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
    expect(channel_site_map[:site_id]).to eq(@site_id)
    expect(channel_site_map[:channel_id]).to eq(@channel_id)
    expect(channel_site_map[:priority]).to eq(10)
  end

  it "should retrieve a list of sites in a channel" do
    sites = @csm.sites_in_channel(@channel_id)
    expect(sites[:site_ids]).to include(@site_id)
  end

  it "should retrieve a list of channels in a site" do
    channels = @csm.channels_in_site(@site_id)
    expect(channels[:channel_ids]).to include(@channel_id)
  end

  it "should list a specific map" do
    channel_site_map = @csm.get(@channel_id, @site_id)
    expect(channel_site_map[:site_id]).to eq(@site_id)
    expect(channel_site_map[:channel_id]).to eq(@channel_id)
    expect(channel_site_map[:priority]).to eq(10)
  end

  it "should update a map" do
    u_map = {
     :site_id => @site_id,
     :channel_id => @channel_id,
     :priority => 200
    }
    channel_map = @csm.update(u_map)
    expect(channel_map[:priority]).to eq(200)
  end

  it "should list all maps for network" do
    channel_maps = @csm.list
    expect(channel_maps[:items].last[:site_id]).to eq(@site_id)
  end

  it "should delete a new maps" do
    response = @csm.delete(@channel_id, @site_id)
    expect(response.body).to eq('"Successfully deleted."')
  end

end
