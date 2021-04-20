module Adzerk
  class InstantCount
    include Adzerk::Util

    def initialize(args={})
      @client = args[:client]
    end

    def bulk(data={})
      url = "instantcounts/bulk"
      response = @client.post_json_request(url, data)
      parse_response(response)
    end

    def network_counts()
      url = "instantcounts/network?days=7"
      parse_response(@client.get_request(url))
    end
  end
end