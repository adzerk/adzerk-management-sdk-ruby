require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Publisher API" do

  before(:all) do
    client = Adzerk::Client.new(API_KEY)
    @publishers = client.publishers
    @rand = rand(1000000).to_s
  end

  it "should create a new publisher" do
    new_publisher = {
     :first_Name => 'John' + @rand,
     :last_name => 'Doe' + @rand,
     :company_name => 'Company' + @rand,
     :address => {
       :line1 => "1001 Invalid St",
       :line2 => "Unit 302",
       :city => "San Francisco",
       :state_province => "CA",
       :postal_code => "90210",
       :country => "USA"
     },
     :payment_option => 1, # this is paypal
     :paypal_email => "johndoe+" + @rand + "@johndoe.com"
    }
    publisher = @publishers.create(new_publisher)
    $publisher_id = publisher[:id]
    publisher[:first_name].should eq('John' + @rand)
    publisher[:last_name].should eq('Doe' + @rand)
    publisher[:company_name].should eq('Company' + @rand)
    publisher[:payment_option].should eq("1")
    publisher[:paypal_email].should eq("johndoe+" + @rand + "@johndoe.com")
    publisher[:address].should_not be_nil
    $address_id = publisher[:address][:id].to_s
  end

  it "should list a specific publisher" do
    publisher = @publishers.get($publisher_id)
    publisher[:first_name].should eq('John' + @rand)
    publisher[:last_name].should eq('Doe' + @rand)
    publisher[:company_name].should eq('Company' + @rand)
    publisher[:payment_option].should eq("PayPal")
    publisher[:paypal_email].should eq("johndoe+" + @rand + "@johndoe.com")
    publisher[:address].should_not be_nil
   end

  it "should update a publisher" do
    updated_publisher = {
     :id => $publisher_id,
     :first_Name => 'Rafael' + @rand,
     :last_name => 'Doe' + @rand,
     :company_name => 'Company' + @rand,
     :address => {
       :line1 => "1001 Invalid St",
       :line2 => "Unit 302",
       :city => "San Francisco",
       :state_province => "CA",
       :postal_code => "90210",
       :country => "USA"
     },
     :payment_option => 1, # this is paypal
     :paypal_email => "johndoe+" + @rand + "@johndoe.com"
    }
    publisher = @publishers.update(updated_publisher)
    publisher[:first_name].should eq("Rafael" + @rand)
  end

  it "should list all publishers" do
    publishers = @publishers.list

    publisher = publishers[:items].last
    publisher[:id].should eq($publisher_id)
  end

  it "should delete a new publisher" do
    response = @publishers.delete($publisher_id)
    response.body.should == '"Successfully deleted"'
  end

  it "should retrieve publisher earnings" do
    earnings = {
      'Channel' => 'all'
    }
    #response = @@publisher.earnings earnings
    #response.first.length.should == 12
  end

  it "should retrieve publisher earnings for previous month" do
    earnings = {
      'Channel' => 'all',
      'Month' => 'previous'
    }
    #response = @@publisher.earnings earnings
    #response.first.length.should == 12
  end

  it "should retrieve publisher earnings for individual channel" do
    earnings = {
      'Channel' => '1127'
    }
    #response = @@publisher.earnings earnings
    #response.first.length.should == 12
  end

  it "should retrieve publisher payments for a network" do
    payments = { }
    response = @publishers.payments payments
    #response.first.length.should == 5
  end

  it "should retrieve publisher payments for a network with start and end date" do
    payments = { 
      'StartDate' => '01/01/2000',
      'EndDate' => '03/01/2000'
    }
    response = @publishers.payments payments
    response.first.should == nil
  end

  it "should retrieve publisher payments for a network with only start date" do
    payments = { 
      'StartDate' => '01/01/2012'
    }
    response = @publishers.payments payments
    #response.first.length.should == 5
  end

  it "should retrieve publisher payments for a site" do
    payments = { 
      #'SiteId' => 6872
    }
    response = @publishers.payments payments
  end

  it "should retrieve publisher payments for a publisher" do
    payments = { 
      #'PublisherAccountId' => 644
    }
    response = @publishers.payments payments
  end

end
