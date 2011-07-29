require "rubygems"
require "json"
require "net/http"
require 'net/http/post/multipart'

module Adzerk
  
  @@header = 'X-Adzerk-ApiKey'
  $host = 'http://api.adzerk.net/v1/'
  
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
  
  def self.post_multipart(uri, data, imagepath)
    File.open(imagepath) do |image|
      req = Net::HTTP::Post::Multipart.new url.path,
        "file" => UploadIO.new(image, "image/gif", "image.gif")
      req.add_field @@header, @@api_key
      req.set_form_data(data)
      res = Net::HTTP.start(url.host, url.port) do |http|
        http.request(req)
      end
    end
  end
  
end