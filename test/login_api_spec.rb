require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

def random_email
  "test@email-#{rand(1000000)}.com"
end

describe "Login_API" do

  before do
    @logins = Adzerk::Client.new(API_KEY).logins
  end

  it "should create a new login" do
    email = random_email()
    login = @logins.create(:email => email,
                           :password => '1234567',
                           :name => "John Doe")
    $login_id = login[:id]
    expect(login[:email]).to eq(email)
    # Password is redacted in the response.
    expect(login[:password]).to eq("")
    expect(login[:name]).to eq("John Doe")
  end

  it "should list all logins" do
    logins = @logins.list
    expect(logins[:items].last[:id]).to eq($login_id)
  end

  it "should list a specific login" do
    login = @logins.get($login_id)
    expect(login[:name]).to eq("John Doe")
  end

  it "should update a login" do
    new_email = random_email()
    login = @logins.update(:id => $login_id,
                           :name => "New Name",
                           :email => new_email)
    expect(login[:name]).to eq("New Name")
  end

end
