module Adzerk
  class Client

    include Adzerk::Util

    attr_reader :sites, :ad_types, :zones, :campaigns, :channels, :priorities,
                :advertisers, :flights, :creatives, :creative_maps,
                :publishers, :invitations, :reports, :channel_site_maps,
                :logins, :geotargetings, :sitezonetargetings, :categories,
                :instant_counts, :ads, :creative_templates, :scheduled_reports, 
                :day_parts, :distance_targetings

    VERSION = Gem.loaded_specs['adzerk'].version.to_s
    SDK_HEADER_NAME = 'X-Adzerk-Sdk-Version'
    SDK_HEADER_VALUE = "adzerk-management-sdk-ruby:#{VERSION}"
    BASE_SLEEP = 0.25
    MAX_SLEEP = 5
    MAX_ATTEMPTS = 10

    DEFAULTS = {
      :host => ENV["ADZERK_API_HOST"] || 'https://api.adzerk.net/',
      :header => 'X-Adzerk-ApiKey',
      :include_creative_templates => true
    }

    def initialize(key, opts = {})
      @api_key = key
      @config = DEFAULTS.merge!(opts)
      @logins = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'login')
      @sites = Adzerk::Site.new(:client => self, :endpoint => 'site')
      @ad_types = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'adtypes', :subendpoint => 'channel', :datakey => 'adtype')
      @flights = Adzerk::Flight.new(:client => self, :endpoint => 'flight')
      @zones = Adzerk::ApiEndpoint.new(:client => self, :endpoint => 'zone')
      @campaigns = Adzerk::Campaign.new(:client => self, :endpoint => 'campaign')
      @channels = Adzerk::Channel.new(:client => self, :endpoint => 'channel')
      @priorities = Adzerk::Priority.new(:client => self, :endpoint => 'priority')
      @advertisers = Adzerk::Advertiser.new(:client => self, :endpoint => 'advertiser')
      @publishers = Adzerk::Publisher.new(:client => self, :endpoint => 'publisher')
      @creatives = Adzerk::Creative.new(:client => self, :endpoint => 'creative')
      @creative_maps = Adzerk::CreativeMap.new(:client => self)
      @ads = @creative_maps
      @invitations = Adzerk::Invitation.new(:client => self)
      @reports = Adzerk::Reporting.new(:client => self)
      @channel_site_maps = Adzerk::ChannelSiteMap.new(:client => self)
      @geotargetings = Adzerk::GeoTargeting.new(:client => self, :endpoint => 'geotargeting')
      @sitezonetargetings = Adzerk::SiteZoneTargeting.new(:client => self, :endpoint => 'sitezone')
      @categories = Adzerk::Category.new(:client => self, :endpoint => 'category')
      @instant_counts = Adzerk::InstantCount.new(:client => self)
      @creative_templates = Adzerk::CreativeTemplate.new(:client => self)
      @scheduled_reports = Adzerk::ScheduledReporting.new(:client => self, :endpoint => 'report')
      @day_parts = Adzerk::DayParting.new(:client => self, :endpoint => 'dayparting')
      @distance_targetings = Adzerk::DistanceTargeting.new(:client => self, :endpoint => 'distancetargeting')
    end

    def get_request(url, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Get.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      send_request(request, uri)
    end

    def delete_request(url, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Delete.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      send_request(request, uri)
    end

    def post_request(url, data, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Post.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      request.set_form_data(data)
      send_request(request, uri)
    end

    def post_json_request(url, data, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      request.body = data.to_json
      send_request(request, uri)
    end

    def put_request(url, data, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Put.new(uri.request_uri)
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      request.set_form_data(data)
      send_request(request, uri)
    end

    def put_json_request(url, data, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      request = Net::HTTP::Put.new(uri.request_uri, 'Content-Type' => 'application/json')
      request.add_field(@config[:header], @api_key)
      request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
      request.body = data.to_json
      send_request(request, uri)
    end

    def filter(url, version: 'v1')
      uri = URI.parse("#{@config[:host]}#{version}/#{url}")
      Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |https|
        request = Net::HTTP::Get.new uri
        request.add_field(@config[:header], @api_key)
        request.add_field(SDK_HEADER_NAME, SDK_HEADER_VALUE)
        https.request request do |response|
          arr = []
          response.read_body do |segment|
            str = ''
            str.concat(segment)
            split_str = str.split(/(?<=[\n])/)
            for line in split_str do
              begin
                obj = JSON.parse(line)
              rescue => exception
                str.concat(line)
              else
                arr.append(obj)
              end
            end
            return arr
          end
        end
      end
    end

    def create_creative(data={}, image_path='', version: 'v1')
      response = nil
      attempt = 0

      loop do
        response = RestClient.post(@config[:host] + version + '/creative',
                                  {:creative => camelize_data(data).to_json},
                                    :X_Adzerk_ApiKey => @api_key,
                                    :X_Adzerk_Sdk_Version => SDK_HEADER_VALUE,
                                    :accept => :json)
        break if response.code != 429 or attempt >= (@config[:max_attempts] || MAX_ATTEMPTS)
        sleep(rand(0.0..[MAX_SLEEP, BASE_SLEEP * 2 ** attempt].min()))
        attempt += 1
      end
      response = upload_creative(JSON.parse(response)["Id"], image_path) unless image_path.empty?
      response
    end

    def upload_creative(id, image_path, size_override: false, version: 'v1')
      response = nil
      attempt = 0
      image = File.new(image_path, 'rb')
      url = @config[:host] + version + '/creative/' + id.to_s + '/upload'
      url += '?sizeOverride=true' if size_override
      loop do
        response = RestClient.post(url,
        {:image => image},
        "X-Adzerk-ApiKey" => @api_key,
        SDK_HEADER_NAME => SDK_HEADER_VALUE,
        :accept => :mime)

        break if response.code != 429 or attempt >= (@config[:max_attempts] || MAX_ATTEMPTS)
        sleep(rand(0.0..[MAX_SLEEP, BASE_SLEEP * 2 ** attempt].min()))
        attempt += 1
      end
      response
    end

    def send_request(request, uri)
      response = nil
      attempt = 0
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = uri.scheme == 'https'

      loop do
        response = http.request(request)
        break if response.code != "429" or attempt >= (@config[:max_attempts] || MAX_ATTEMPTS)
        sleep(rand(0.0..[MAX_SLEEP, BASE_SLEEP * 2 ** attempt].min()))
        attempt += 1
      end

      if response.kind_of? Net::HTTPClientError or response.kind_of? Net::HTTPServerError
        error_response = JSON.parse(response.body)
        msg = error_response["message"] || error_response["Error"] || response.body
        raise Adzerk::ApiError.new(msg)
      end

      response
    end

  end
end
