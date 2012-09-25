module Adzerk
  class Client
    attr_reader :sites, :zones, :campaigns, :channels, :priorities

    DEFAULTS = {
      :host => ENV["ADZERK_API_HOST"] || 'http://api.adzerk.net/v1/',
      :header => 'X-Adzerk-ApiKey'
    }

    def initialize(key, opts = {})
      @api_key = key
      @config = DEFAULTS.merge!(opts)
      @sites = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'site')
      @zones = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'zone')
      @campaigns = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'campaign')
      @channels = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'channel')
      @priorities = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'priority')
    end

    def get_request(url)
      uri = URI.parse(@config[:host] + url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      http.request(request)
    end

    def post_request(url, data)
      uri = URI.parse(@config[:host] + url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.set_form_data(data)
      http.request(request)
    end

    def put_request(url, data)
      uri = URI.parse(@config[:host] + url)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Put.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.set_form_data(data)
      http.request(request)
    end

    def upload_creative(id, imagepath)
      begin
        image = File.new(imagepath, 'rb')
      rescue
        image = ''
      end

      RestClient.post @config[:host] + 'creative/' + id.to_s + '/upload',
      {:image => image},
      "X-Adzerk-ApiKey" => @api_key,
      :accept => :mime
    end
  end
end
