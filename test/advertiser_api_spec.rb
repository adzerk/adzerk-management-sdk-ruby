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
    expect($title).to eq(advertiser[:title])
    expect($is_active).to eq(advertiser[:is_active])
    expect($is_deleted).to eq(advertiser[:is_deleted])
  end

  it "should list a specific advertiser" do
    advertiser = @advertisers.get($advertiser_id)
    expect($title).to eq(advertiser[:title])
    expect($is_active).to eq(advertiser[:is_active])
    expect($is_deleted).to eq(advertiser[:is_deleted])
  end

  it "should list all advertisers" do
    result = @advertisers.list
    expect(result.length).to be > 0
    advertiser = result[:items].last
    expect($title).to eq(advertiser[:title])
    expect($is_active).to eq(advertiser[:is_active])
    expect($is_deleted).to eq(advertiser[:is_deleted])
    expect($advertiser_id).to eq(advertiser[:id].to_s)
  end

  it "should update a advertiser" do
    advertiser = @advertisers.update(:id => $advertiser_id,
                                     :title => "Cocacola",
                                     :is_active => false)
    expect(advertiser[:title]).to eq("Cocacola")
    expect(advertiser[:is_active]).to eq(false)
  end

  it "should search advertiser based on name" do
    advertiser = @advertisers.search("Cocacola")
    expect(advertiser[:total_items]).to be > 0
  end

  it "should get advertiser instant counts" do
    count = @advertisers.instant_counts($advertiser_id)
    expect(count.length).to be > 0
  end

  it "should delete a new advertiser" do
    response = @advertisers.delete($advertiser_id)
    expect(response.body).to eq('"Successfully deleted."')
  end

  it "should not list deleted advertisers" do
    response = @advertisers.list
    response[:items].each do |r|
      expect(r["Id"]).not_to eq($advertiser_id)
    end
  end

  it "should get individual deleted advertiser" do
    advertiser = @advertisers.get $advertiser_id
    expect(advertiser[:is_deleted]).to eq(true)
  end

  it "should not update a deleted advertiser" do
    expect { @advertisers.update(:id => $advertiser_id, :title => "Cocacola") }.to raise_error("This advertiser is deleted.")
  end

  it "should require a title" do
    expect{ @advertisers.create() }.to raise_error("A title is required.")
  end

end
