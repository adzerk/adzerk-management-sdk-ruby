module Adzerk
  class Advertiser < ApiEndpoint
    def search(advertiser_name)
      url = 'advertiser/search'
      data = { 'advertiserName' => advertiser_name }
      parse_response(client.post_request(url, data))
    end
  end
end
