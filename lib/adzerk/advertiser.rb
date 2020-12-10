module Adzerk
  class Advertiser < ApiEndpoint
    def search(advertiser_name)
      url = 'advertiser/search'
      data = { 'advertiserName' => advertiser_name }
      parse_response(client.post_request(url, data))
    end

    def instant_counts(advertiser_id)
      url = "instantcounts/#{endpoint}/#{advertiser_id}"
      parse_response(client.get_request(url))
    end

    def list_creatives(advertiser_id)
      url = "advertiser/#{advertiser_id}/creatives"
      parse_response(@client.get_request(url))
    end
  end
end
