require File.expand_path(File.dirname(__FILE__) + '/spec_helper')
require 'net/http'

describe "Channel API security" do

  it "should reject unauthenticated GET requests" do
    uri = URI.parse(API_HOST + 'channel/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.request_uri)
    expect(http.request(request).response.code).not_to eq(200)
  end

  it "should reject GET requests with null API keys" do
    uri = URI.parse(API_HOST + 'channel/')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = uri.scheme == 'https'
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field "X-Adzerk-ApiKey", ""
    expect(http.request(request).response.code).not_to eq(200)
  end

end
