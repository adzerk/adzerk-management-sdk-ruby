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

end
