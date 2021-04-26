module Adzerk
  class Campaign < ApiEndpoint
    def instant_counts(campaign_id, data={})
      query_string = URI.encode_www_form(data)
      url = "instantcounts/#{endpoint}/#{campaign_id}?#{query_string}"
      parse_response(client.get_request(url))
    end

    def search(campaign_name)
      url = 'campaign/search'
      data = { 'campaignName' => campaign_name }
      parse_response(client.post_request(url, data))
    end
  end
end