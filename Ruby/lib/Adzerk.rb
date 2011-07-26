require "rubygems"
require "json"
require "net/http"

module Adzerk
  
  @@header = 'X-Adzerk-ApiKey'
  $host = 'http://10.0.1.51/v1/'
  
  def self.new(key)
    @@api_key = key
    return self
  end
  
  def self.get_request(uri)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Get.new(uri.request_uri)
    request.add_field @@header, @@api_key
    http.request(request)
  end

  def self.post_request(uri, data)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Post.new(uri.request_uri)
    request.add_field @@header, @@api_key
    request.set_form_data(data)
    http.request(request)
  end
  
  def self.put_request(uri, data)
    http = Net::HTTP.new(uri.host, uri.port)
    request = Net::HTTP::Put.new(uri.request_uri)
    request.add_field @@header, @@api_key
    request.set_form_data(data)
    http.request(request)
  end
  
end