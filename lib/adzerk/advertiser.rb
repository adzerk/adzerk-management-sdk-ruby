module Adzerk
  class Advertiser < ApiEndpoint
    def search(advertiser_name)
      url = 'advertiser/search'
      data = { 'advertiserName' => advertiser_name }
      parse_response(client.post_request(url, data))
    end

    def instant_counts(advertiser_id, data={})
      query_string = URI.encode_www_form(data)
      url = "instantcounts/#{endpoint}/#{advertiser_id}?#{query_string}"
      parse_response(client.get_request(url))
    end

    def list_creatives(advertiser_id, page: 1, pageSize: 500)
      url = "advertiser/#{advertiser_id}/creatives?page=#{page}&pageSize=#{pageSize}"
      parse_response(@client.get_request(url))
    end
  end
end
