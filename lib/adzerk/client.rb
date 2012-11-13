module Adzerk
  class Client

    include Adzerk::Util

    attr_reader :sites, :zones, :campaigns, :channels, :priorities,
                :advertisers, :flights, :creatives, :creative_maps,
                :publishers, :invitations, :reports
      
    DEFAULTS = {
      :host => ENV["ADZERK_API_HOST"] || 'http://api.adzerk.net/v1/',
      :header => 'X-Adzerk-ApiKey'
    }

    def initialize(key, opts = {})
      @api_key = key
      @config = DEFAULTS.merge!(opts)
      @sites = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'site')
      @flights = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'flight')
      @zones = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'zone')
      @campaigns = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'campaign')
      @channels = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'channel')
      @priorities = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'priority')
      @advertisers = Adzerk::Advertiser.new(:client => self, :endpoint => 'advertiser')
      @publishers = Adzerk::Publisher.new(:client => self, :endpoint => 'publisher')
      @creatives = Adzerk::Creative.new(:client => self, :endpoint => 'creative')
      @creative_maps = Adzerk::CreativeMap.new(:client => self)
      @invitations = Adzerk::Invitation.new(:client => self)
      @reports = Adzerk::Reporting.new(:client => self)
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

    def create_creative(data={}, image_path='')      
      response = RestClient.post(@config[:host] + 'creative',
                                 {:creative => camelize_data(data).to_json},
                                 :X_Adzerk_ApiKey => @api_key,
                                 :content_type => :json, 
                                 :accept => :json)
      response = upload_creative(JSON.parse(response)["Id"], image_path) unless image_path.empty?
      response
    end

    def upload_creative(id, image_path)
      image = File.new(image_path, 'rb')
      RestClient.post(@config[:host] + 'creative/' + id.to_s + '/upload',
      {:image => image},
      "X-Adzerk-ApiKey" => @api_key,
      :accept => :mime)
    end

  end
end
