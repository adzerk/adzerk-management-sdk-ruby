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
  end
end