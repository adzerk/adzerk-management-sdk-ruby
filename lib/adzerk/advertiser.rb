module Adzerk
  class Advertiser < ApiEndpoint
    def search(advertiser_name)
      url = 'advertiser/search'
      data = { 'advertiserName' => advertiser_name }
      parse_response(client.post_request(url, data))
    end

    def instant_counts(id)
      url = "instantcounts/#{endpoint}/#{id}"
      parse_response(client.get_request(url))
    end
  end
end
