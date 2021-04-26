module Adzerk
  class Flight < ApiEndpoint
    def countries
      parse_response(@client.get_request('countries'))
    end

    def regions(region)
      url = 'region/' + region
      parse_reponse(@client.get_request(url))
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
      parse_response(@client.get_request(url))
    end
  end
end
