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

  it "should create a new zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    zone = @zones.create(:name => $name,
                         :site_id => $site_id,
                         :is_deleted => false)
    $zone_id = zone[:id].to_s
    zone[:name].should == $name
    zone[:site_id].should == $site_id
    zone[:is_deleted].should == false
  end

  it "should list a specific zone" do
    zone = @zones.get($zone_id)
    zone[:id].should eq($zone_id.to_i)
    zone[:name].should eq($name)
    zone[:site_id].should eq($site_id)
    zone[:is_deleted].should eq(false)
  end

  it "should update a zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    zone = @zones.update(:id => $zone_id,
                             :name => $name,
                             :site_id => $site_id,
                             :is_deleted => false)
    zone[:id].should eq($zone_id.to_i)
    zone[:name].should eq($name)
    zone[:site_id].should eq($site_id)
    zone[:is_deleted].should eq(false)
  end

  it "should list all zones" do
    result = @zones.list
    result.length.should > 0
    result[:items].last[:id].to_s.should == $zone_id
    result[:items].last[:name].should == $name
    result[:items].last[:site_id].should == $site_id
    result[:items].last[:is_deleted].should == false
  end

  it "should delete a new zone" do
    response = @zones.delete($zone_id)
    response.body.should == '"Successfully deleted"'
  end

end
