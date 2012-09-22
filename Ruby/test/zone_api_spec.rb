require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Zone API" do
  
  @@zone = $adzerk::Zone.new
  @@site = $adzerk::Site.new
  
  before(:all) do
    new_site = {
     'Title' => 'Test Site ' + rand(1000000).to_s,
     'Url' => 'http://www.adzerk.com'
    }
    response = @@site.create(new_site)
    $site_id = JSON.parse(response.body)["Id"]
  end
  
  it "should create a new zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    new_zone = {
     'Name' => $name,
     'SiteId' => $site_id,
     'IsDeleted' => false
    }
    response = @@zone.create(new_zone)
    $zone_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Name"].should == $name
    JSON.parse(response.body)["SiteId"].should == $site_id
    JSON.parse(response.body)["IsDeleted"].should == false 
  end
  
  it "should list a specific zone" do
    response = @@zone.get($zone_id)
    response.body.should == '{"Id":' + $zone_id + ',"Name":"' + $name + '","SiteId":' + $site_id.to_s + ',"IsDeleted":false}'
  end

  it "should update a zone" do
    $name = 'Test Zone ' + rand(1000000).to_s
    updated_zone = {
     'Id' => $zone_id,
     'Name' => $name,
     'SiteId' => $site_id,
     'IsDeleted' => false
    }
    response = @@zone.update(updated_zone)
    JSON.parse(response.body)["Id"].to_s.should == $zone_id
    JSON.parse(response.body)["Name"].should == $name
    JSON.parse(response.body)["SiteId"].should == $site_id
    JSON.parse(response.body)["IsDeleted"].should == false 
  end

  it "should list all zones" do
    result = @@zone.list()
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $zone_id
    result["Items"].last["Name"].should == $name 
    result["Items"].last["SiteId"].should == $site_id
    result["Items"].last["IsDeleted"].should == false 
  end

  it "should delete a new zone" do
    response = @@zone.delete($zone_id)
    response.body.should == 'OK'
  end

  it "should not list deleted zones" do
    result = @@zone.list()
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $zone_id
    end
  end

  it "should not get individual deleted zones" do
    response = @@zone.get($zone_id)
    response.body.should == '{"Id":0,"SiteId":0}'
  end

  it "should not update deleted zones" do
    $name = 'Test Zone ' + rand(1000000).to_s
    updated_zone = {
     'Id' => $zone_id,
     'Name' => $name,
     'SiteId' => $site_id,
     'IsDeleted' => false
    }
    response = @@zone.update(updated_zone)
    response.body.should == '{"Id":0,"SiteId":0}'
  end

end
