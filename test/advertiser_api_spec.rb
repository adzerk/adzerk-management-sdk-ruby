require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Advertiser API" do

  before do
    @advertisers = Adzerk::Client.new(API_KEY).advertisers
  end

  it "should create a new advertiser" do
    $title = 'Test advertiser ' + rand(1000000).to_s
    $is_active = true
    $is_deleted = false

    advertiser = @advertisers.create(:title => $title,
                                     :is_active => $is_active,
                                     :is_deleted => $is_deleted)
    $advertiser_id = advertiser[:id].to_s
    $title.should == advertiser[:title]
    $is_active.should == advertiser[:is_active]
    $is_deleted.should == advertiser[:is_deleted]
  end

  it "should list a specific advertiser" do
    advertiser = @advertisers.get($advertiser_id)
    $title.should == advertiser[:title]
    $is_active.should == advertiser[:is_active]
    $is_deleted.should == advertiser[:is_deleted]
  end

  it "should list all advertisers" do
    result = @advertisers.list
    result.length.should > 0
    advertiser = result[:items].last
    $title.should == advertiser[:title]
    $is_active.should == advertiser[:is_active]
    $is_deleted.should == advertiser[:is_deleted]
    $advertiser_id.should == advertiser[:id].to_s
  end

  it "should update a advertiser" do
    advertiser = @advertisers.update(:id => $advertiser_id,
                                     :title => "Cocacola",
                                     :is_active => false)
    advertiser[:title].should eq("Cocacola")
    advertiser[:is_active].should eq(false)
  end

  it "should search advertiser based on name" do
    advertiser = @advertisers.search("Cocacola")
    advertiser[:total_items].should > 0
  end

  it "should delete a new advertiser" do
    response = @advertisers.delete($advertiser_id)
    response.body.should == '"Successfully deleted."'
  end

  it "should not list deleted advertisers" do
    response = @advertisers.list
    response[:items].each do |r|
      r["Id"].should_not == $advertiser_id
    end
  end

  it "should not get individual deleted advertiser" do
    response = @advertisers.get $advertiser_id
    response[:message].should eq("This advertiser is deleted.")
  end

  it "should not update a deleted advertiser" do
    advertiser = @advertisers.update(:id => $advertiser_id,
                                     :title => "Cocacola")
    advertiser[:message].should eq("This advertiser is deleted.")
  end

  it "should require a title" do
    response = @advertisers.create()
    response[:message].should eq("A title is required.")
  end

end
