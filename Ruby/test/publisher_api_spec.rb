require './spec_helper'

describe "Publisher API" do
  
  @@publisher = $adzerk::Publisher.new
  
  it "should create a new publisher" do
    $rand = rand(1000000).to_s
    $publisher_first = 'Test ' + $rand
    $publisher_last = 'Person ' + $rand
    $publisher_company = 'Company ' + $rand
    $publisher_line1 = $rand + 'st'
    $publisher_line2 = 'Apt. ' + $rand
    $publisher_city = $rand + 'ville'
    $publisher_state = 'NC'
    $publisher_zip = $rand.to_s
    $publisher_country = 'USA'
    $publisher_payment_option = "1"
    $publisher_paypal_email = 'Test' + $rand + '@test.com'
    $new_publisher = {
     'FirstName' => $publisher_first,
     'LastName' => $publisher_last,
     'CompanyName' => $publisher_company,
     'Address' => {
       'Line1' => $publisher_line1,
       'Line2' => $publisher_line2,
       'City' => $publisher_city,
       'StateProvince' => $publisher_state,
       'PostalCode' => $publisher_zip,
       'Country' => $publisher_country
     },
     'PaymentOption' => $publisher_payment_option,
     'PaypalEmail' => $publisher_paypal_email
    }
    response = @@publisher.create($new_publisher)
    $publisher_id = JSON.parse(response.body)["Id"].to_s
    $publisher_first.should == JSON.parse(response.body)["FirstName"]
    $publisher_last.should == JSON.parse(response.body)["LastName"]
    $publisher_company.should == JSON.parse(response.body)["CompanyName"]
    JSON.parse(response.body)["PaymentOption"].should == "1"
    $publisher_paypal_email.should == JSON.parse(response.body)["PaypalEmail"]
    
    $address_id = JSON.parse(response.body)["Address"]["Id"].to_s
    $publisher_line1.should == JSON.parse(response.body)["Address"]["Line1"]
    $publisher_line2.should == JSON.parse(response.body)["Address"]["Line2"]
    $publisher_city.should == JSON.parse(response.body)["Address"]["City"]
    $publisher_state.should == JSON.parse(response.body)["Address"]["StateProvince"]
    $publisher_zip.should == JSON.parse(response.body)["Address"]["PostalCode"]
    $publisher_country.should == JSON.parse(response.body)["Address"]["Country"]
  end
  
  it "should list a specific publisher" do
     response = @@publisher.get($publisher_id)
     response.body.should == '{"Id":' + $publisher_id + ',"FirstName":"' + $publisher_first + '","LastName":"' + $publisher_last + '","CompanyName":"' + $publisher_company + '","Address":{"Id":' + $address_id + ',"Line1":"' + $publisher_line1 + '","Line2":"' + $publisher_line2 + '","City":"' + $publisher_city + '","StateProvince":"' + $publisher_state + '","PostalCode":"' + $publisher_zip + '","Country":"' + $publisher_country + '"},"PaypalEmail":"' + $publisher_paypal_email + '","PaymentOption":"PayPal","IsDeleted":false}'
   end

  it "should update a publisher" do
    $new_publisher = {
      'Id' => $publisher_id,
      'FirstName' => $publisher_first + "test",
      'LastName' => $publisher_last + "test",
      'CompanyName' => $publisher_company + "test",
      'Address' => {
       'Line1' => $publisher_line1 + "test",
       'Line2' => $publisher_line2 + "test",
       'City' => $publisher_city + "test",
       'StateProvince' => $publisher_state + "test",
       'PostalCode' => $publisher_zip + "test",
       'Country' => $publisher_country + "test"
      },
      'PaymentOption' => $publisher_payment_option,
      'PaypalEmail' => $publisher_paypal_email + "test"
    }
    response = @@publisher.update($new_publisher)
    $publisher_id = JSON.parse(response.body)["Id"].to_s
    ($publisher_first + "test").should == JSON.parse(response.body)["FirstName"]
    ($publisher_last + "test").should == JSON.parse(response.body)["LastName"]
    ($publisher_company + "test").should == JSON.parse(response.body)["CompanyName"]
    JSON.parse(response.body)["PaymentOption"].should == "1"
    ($publisher_paypal_email + "test").should == JSON.parse(response.body)["PaypalEmail"]
    
    $address_id = JSON.parse(response.body)["Address"]["Id"].to_s
    ($publisher_line1 + "test").should == JSON.parse(response.body)["Address"]["Line1"]
    ($publisher_line2 + "test").should == JSON.parse(response.body)["Address"]["Line2"]
    ($publisher_city + "test").should == JSON.parse(response.body)["Address"]["City"]
    ($publisher_state + "test").should == JSON.parse(response.body)["Address"]["StateProvince"]
    ($publisher_zip + "test").should == JSON.parse(response.body)["Address"]["PostalCode"]
    ($publisher_country + "test").should == JSON.parse(response.body)["Address"]["Country"]
  end

  it "should list all publishers" do
    result = @@publisher.list()
    result.length.should > 0
    result["Items"].last["Id"].to_s.should == $publisher_id
    result["Items"].last["FirstName"].should == $publisher_first + "test"
    result["Items"].last["LastName"].should == $publisher_last + "test"
    result["Items"].last["CompanyName"].should == $publisher_company + "test"
    result["Items"].last["PaymentOption"].should == "PayPal"
    result["Items"].last["PaypalEmail"].should == $publisher_paypal_email + "test"
    
    result["Items"].last["Address"]["Line1"].should == $publisher_line1 + "test"
    result["Items"].last["Address"]["Line2"].should == $publisher_line2 + "test"
    result["Items"].last["Address"]["City"].should == $publisher_city + "test"
    result["Items"].last["Address"]["StateProvince"].should == $publisher_state + "test"
    result["Items"].last["Address"]["PostalCode"].should == $publisher_zip + "test"
    result["Items"].last["Address"]["Country"].should == $publisher_country + "test"
  end

  it "should delete a new publisher" do
    response = @@publisher.delete($publisher_id)
    response.body.should == 'OK'
  end

  it "should not list deleted publishers" do
    result = @@publisher.list()
    result["Items"].each do |r|
      r["Id"].to_s.should_not == $publisher_id.to_s
    end
  end

  it "should not get individual deleted publishers" do
    response = @@publisher.get($publisher_id)
    response.body.should == '{"Id":0,"IsDeleted":false}'
  end

  it "should not update deleted publishers" do
    $updated_publisher = {
      'Id' => $publisher_id,
      'FirstName' => $publisher_first + "test",
      'LastName' => $publisher_last + "test",
      'CompanyName' => $publisher_company + "test",
      'Address' => {
        'Line1' => $publisher_line1 + "test",
        'Line2' => $publisher_line2 + "test",
        'City' => $publisher_city + "test",
        'StateProvince' => $publisher_state + "test",
        'PostalCode' => $publisher_zip + "test",
        'Country' => $publisher_country + "test"
      },
      'PaymentOption' => $publisher_payment_option,
      'PaypalEmail' => $publisher_paypal_email + "test"
    }
    response = @@publisher.update($updated_publisher)
    response.body.should == '{"Id":0,"IsDeleted":false}'
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

end