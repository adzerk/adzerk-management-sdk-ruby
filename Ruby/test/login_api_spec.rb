require 'spec_helper'

describe "Login_API" do
  
  login_id = '484'

  # it "should_list_all_logins_to_network" do
  #   uri = URI.parse($host << '/login')
  #   response = get_request(uri)
  #   puts response.code
  #   puts response.body    
  # end
  
  it "should_create_a_new_login" do
    uri = URI.parse($host + '/login')
    new_login = { 
      'Id' => '5055',
      'Email' => 'noreply+' + rand(1000000).to_s + '@adzerk.com',
      'Name' => 'Test',
      'Password' => 'XXXX'
    }
    data = { 'login' => new_login.to_json }
    response = post_request(uri, data)
    puts response.body
  end
  
  # it "should_list_specific_login_to_network" do
  #   uri = URI.parse($host << '/login/' << login_id)
  #   response = get_request(uri)
  #   puts response.body    
  # end
end