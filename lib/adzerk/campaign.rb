module Adzerk
  class Campaign < ApiEndpoint
    def instant_counts(campaign_id)
      url = "instantcounts/#{endpoint}/#{campaign_id}"
      parse_response(client.get_request(url))
    end

    def search(campaign_name)
      url = 'campaign/search'
      data = { 'campaignName' => campaign_name }
      parse_response(client.post_request(url, data))
    end
  end
end