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

    def network_counts(data={})
      query_string = URI.encode_www_form(data)
      url = "instantcounts/network?#{query_string}"
      parse_response(@client.get_request(url))
    end
  end
end