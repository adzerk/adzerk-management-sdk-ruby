require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Login_API" do

  before do
    @logins = Adzerk::Client.new(API_KEY).logins
  end

  it "should create a new login" do
    email = "test@email_#{rand(1000)}.com"
    login = @logins.create(:email => email,
                           :password => '1234567',
                           :name => "John Doe")
    $login_id = login[:id]
    login[:email].should eq(email)
    login[:password].should eq("1234567")
    login[:name].should eq("John Doe")
  end

  it "should list all logins" do
    logins = @logins.list
    logins[:items].last[:id].should eq($login_id)
  end

  it "should list a specific login" do
    login = @logins.get($login_id)
    login[:name].should eq("John Doe")
  end

  it "should update a login" do
    login = @logins.update(:id => $login_id,
                             :name => "New Name")
    login[:name].should eq("New Name")
  end

end
