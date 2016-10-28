require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zone API" do

  before(:all) do
    @client = Adzerk::Client.new(API_KEY)
    @zones = @client.zones
    @sites = @client.sites
    new_site = {
     'Title' => 'Test Site ' + rand(1000000).to_s,
     'Url' => 'http://www.adzerk.com'
    }
    site = @sites.create(new_site)
    $site_id = site[:id]
  end

  after(:all) do
    @sites.delete($site_id)
  end

  it "should create a new zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    zone = @zones.create(:name => $name,
                         :site_id => $site_id,
                         :is_deleted => false)
    $zone_id = zone[:id].to_s
    expect(zone[:name]).to eq($name)
    expect(zone[:site_id]).to eq($site_id)
    expect(zone[:is_deleted]).to eq(false)
  end

  it "should list a specific zone" do
    zone = @zones.get($zone_id)
    expect(zone[:id]).to eq($zone_id.to_i)
    expect(zone[:name]).to eq($name)
    expect(zone[:site_id]).to eq($site_id)
    expect(zone[:is_deleted]).to eq(false)
  end

  it "should update a zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    zone = @zones.update(:id => $zone_id,
                             :name => $name,
                             :site_id => $site_id,
                             :is_deleted => false)
    expect(zone[:id]).to eq($zone_id.to_i)
    expect(zone[:name]).to eq($name)
    expect(zone[:site_id]).to eq($site_id)
    expect(zone[:is_deleted]).to eq(false)
  end

  it "should list all zones" do
    result = @zones.list
    expect(result.length).to be > 0
    expect(result[:items].any? {|zone| zone[:id].to_s == $zone_id}).to be true
  end

  it "should delete a new zone" do
    response = @zones.delete($zone_id)
    expect(response.body).to eq('"Successfully deleted"')
  end

end
