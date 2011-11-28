require 'spec_helper'

describe "Login_API" do
  
  $login_url = 'http://www.adzerk.com/'
  @@login = $adzerk::Login.new

  it "should list all logins" do
    result = @@login.list()
    result.length.should > 0
    #result["Items"].last["Id"].to_s.should == $site_id
  end

  it "should create a new login" do
    $email = "test+" + rand(10000).to_s + "@adzerk.com"
    $password = "somepassword"
    $fullname = "test person"
    new_login = {
      'Email' => $email,
      'Password' => $password,
      'Name' => $fullname
    }
    response = @@login.create(new_login)
    $login_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Email"].should == $email
    JSON.parse(response.body)["Password"].should == $password
    JSON.parse(response.body)["Name"].should == $fullname
  end
  
  it "should list a specific login" do
    response = @@login.get($login_id)
    response.body.should == '{"Id":' + $login_id.to_s + ',"Email":"'+ $email + '","Password":"","Name":"' + $fullname + '"}'
  end
  
  it "should update a login" do
    new_login = {
      'Id' => $login_id,
      'Name' => $fullname
    }
    response = @@login.update(new_login)
    $login_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Email"].should == $email
    JSON.parse(response.body)["Password"].should == ""
    JSON.parse(response.body)["Name"].should == $fullname
  end

  it "should not be able update a login's password or email" do
    new_login = {
      'Id' => $login_id,
      'Name' => $fullname,
      'Password' => "password",
      'Email' => "test@test.com"
    }
    response = @@login.update(new_login)
    $login_id = JSON.parse(response.body)["Id"].to_s
    JSON.parse(response.body)["Email"].should == $email
    JSON.parse(response.body)["Password"].should == ""
    JSON.parse(response.body)["Name"].should == $fullname
  end

end