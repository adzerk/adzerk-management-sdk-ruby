module Adzerk
  class Campaign < ApiEndpoint
    def instant_counts(id)
      url = "instantcounts/#{endpoint}/#{id}"
      parse_response(client.get_request(url))
    end
  end
end