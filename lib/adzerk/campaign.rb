module Adzerk
  class Campaign < ApiEndpoint
    def instant_counts(campaign_id)
      url = "instantcounts/#{endpoint}/#{campaign_id}"
      parse_response(client.get_request(url))
    end
  end
end