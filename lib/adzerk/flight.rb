module Adzerk
  class Flight < ApiEndpoint
    def countries
      response = @client.get_request('countries')
      parse_response(response)
    end

    def regions(region)
      url = "region/#{region}"
      response = @client.get_request(url)
      parse_response(response)
    end

    def list_regions_for_country(country_code)
      url = "country/#{country_code}/regions?version=2"
      response = @client.get_request(url)
      parse_response(response)
    end

    def instant_counts(flight_id, data={})
      query_string = URI.encode_www_form(data)
      url = "instantcounts/#{endpoint}/#{flight_id}?#{query_string}"
      parse_response(client.get_request(url))
    end

    def list_for_campaign(campaign_id, is_active = nil)
      url = "campaign/#{campaign_id}/flight"
      if !is_active.nil?
        url = "#{url}?isActive=#{is_active}"
      end
      pp url
      parse_response(@client.get_request(url))
    end

    def filter_flights(data={})
      pp data
      # query_string = URI.encode_www_form(data)
      # url = "fast/flight?#{query_string}"
      # Net::HTTP.start(uri.host, uri.port) do |http|
      #   request = Net::HTTP::Get.new uri
      
      #   http.request request do |response|
      #     open 'large_file', 'w' do |io|
      #       response.read_body do |chunk|
      #         io.write chunk
      #       end
      #     end
      #   end
      # end
      # # response = parse_response(client.get_request(url))
      # pp request
    end
  end
end
