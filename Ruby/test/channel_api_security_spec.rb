require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'net/http'

describe "Channel API security" do

  channel_url = 'http://www.adzerk.com'
  channel = $adzerk::Channel.new

  it "should reject unauthenticated GET requests" do
 	uri = URI.parse(ENV['ADZERK_API_HOST'] + 'channel/')	
	http = Net::HTTP.new(uri.host, uri.port)
    	request = Net::HTTP::Get.new(uri.request_uri)
    	http.request(request).response.code.should_not == 200
  end

  it "should reject GET requests with null API keys" do
	uri = URI.parse(ENV['ADZERK_API_HOST'] + 'channel/')
	http = Net::HTTP.new(uri.host, uri.port)
    	request = Net::HTTP::Get.new(uri.request_uri)
    	request.add_field "X-Adzerk-ApiKey", ""
    	http.request(request).response.code.should_not == 200
  end

  it "should reject GET requests with SQL injection attack as API keys" do
        uri = URI.parse(ENV['ADZERK_API_HOST'] + 'channel/')
        http = Net::HTTP.new(uri.host, uri.port)
        request = Net::HTTP::Get.new(uri.request_uri)
        request.add_field "X-Adzerk-ApiKey", "hi' or 1=1--"
        http.request(request).response.code.should_not == 200
  end
  
  it "should reject an attempt to delete a channel not of the same network" do
	channel.delete("14").response.code.should_not == 200	
  end


  it "should reject an attempt to update a channel not of the same network" do
	updated_channel = {
      		'Id' => 14,
     		'Title' => "The Impossible Dream",
      		'Commission' => 0,
      		'Engine' => "CPM",
      		'Keywords' => "bigfoot",
      		'CPM' => "10.00",
      		'AdTypes' => [1,2,3,4]
    	}
	channel.update(updated_channel).response.code.should_not == 200
  end

end


