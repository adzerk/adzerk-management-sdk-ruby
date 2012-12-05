require "rest_client"

module Adzerk
  class Creative < ApiEndpoint

    def create(data= {}, imagepath='')
      response = @client.create_creative(data, imagepath)
      uncamelize_data(JSON.parse(response))
    end

    def list(advertiserId)
      url = 'advertiser/' + advertiserId.to_s + "/creatives"
      parse_response(@client.get_request(url))
    end

  end
end
