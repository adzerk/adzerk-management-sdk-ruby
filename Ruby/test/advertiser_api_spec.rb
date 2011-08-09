require 'spec_helper'

describe "Advertiser API" do
  
  $advertiser_url = 'http://www.adzerk.com'
  @@advertiser = $adzerk::Advertiser.new
  
  it "should create a new advertiser" do
    $title = 'Test advertiser ' + rand(1000000).to_s
    $isActive = true
    $isDeleted = false
    
    new_advertiser = {
      'Title' => $title,
      'IsActive' => $isActive,
      'IsDeleted' => $isDeleted
    }
  
    response = @@advertiser.create(new_advertiser)
    $advertiser_id = JSON.parse(response.body)["Id"].to_s
    $title.should == JSON.parse(response.body)["Title"]
    $isActive.should == JSON.parse(response.body)["IsActive"]
    $isDeleted.should == JSON.parse(response.body)["IsDeleted"]
  end
  
  it "should list a specific advertiser" do
    response = @@advertiser.get($advertiser_id)
    response.body.should == '{"Id":' + $advertiser_id + ',"Title":"' + $title + '","IsActive":' + $isActive.to_s + ',"IsDeleted":' + $isDeleted.to_s + '}'
  end
  
  
  it "should list all advertisers" do
    result = @@advertiser.list()
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $advertiser_id
    result["Items"].last["Title"].should == $title
    result["Items"].last["IsDeleted"].should == $isDeleted
    result["Items"].last["IsActive"].should == $isActive
  end
  
  it "should update a advertiser" do
    $title << "test"
    $isActive = false
    $isDeleted = true
    
    updated_advertiser = {
      'Id' => $advertiser_id.to_i,
      'Title' => $title,
      'IsDeleted' => false,
      'IsActive' => true
    }
    response = @@advertiser.update(updated_advertiser)
    # $advertiser_id = JSON.parse(response.body)["Id"].to_s
    # $title.should == JSON.parse(response.body)["Title"]
    # $isActive.should == JSON.parse(response.body)["IsActive"]
    # $isDeleted.should == JSON.parse(response.body)["IsDeleted"]
  end

  it "should delete a new advertiser" do
    response = @@advertiser.delete($advertiser_id)
    response.body.should == 'OK'
  end
  
  it "should not list deleted advertisers" do
    result = @@advertiser.list()
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $advertiser_id
    end
  end
  
  it "should not get individual deleted advertiser" do
    response = @@advertiser.get($advertiser_id)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should not update deleted advertisers" do
    updated_advertiser = {
      'Id' => $advertiser_id,
      'Title' => "test"
    }
    response = @@advertiser.update(updated_advertiser)
    true.should == !response.body.scan(/Object/).nil?
  end
  
  it "should create a new advertiser without IsActive or IsDeleted" do
    new_advertiser = {
      'Title' => $title
    }
    response = @@advertiser.create(new_advertiser)
    $title.should == JSON.parse(response.body)["Title"]
    JSON.parse(response.body)["IsActive"].should == false
    JSON.parse(response.body)["IsDeleted"].should == false
  end
  
  it "should require a title" do
    new_advertiser = {}
    response = @@advertiser.create(new_advertiser)
    true.should == !response.body.scan(/Object/).nil?
  end

end