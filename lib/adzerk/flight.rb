module Adzerk
  class Flight < ApiEndpoint
    def countries
      parse_response(@client.get_request('countries'))
    end

    def regions(region)
      url = 'region/' + region
      parse_reponse(@client.get_request(url))
    end

    def instant_counts(id)
      url = "instantcounts/#{endpoint}/#{id}"
      parse_response(client.get_request(url))
    end
  end
end
