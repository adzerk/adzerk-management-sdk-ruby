module Adzerk
  class Category

    include Adzerk::Util

    attr_reader :client

    def initialize(args={})
      @client = args[:client]
    end

    def create(flight_id, data={})
      url = "flight/#{flight_id}/category"
      data = { 'category' => camelize_data(data).to_json }
      parse_response(@client.post_request(url, data))
    end

    def delete(flight_id, id)
      url = "flight/#{flight_id}/category/#{id}/delete"
      @client.get_request(url)
    end

    def listAll
      response = client.get_request('categories')
      parse_response(response)
    end

    def list(flight_id)
      url = "flight/#{flight_id}/categories"
      response = client.get_request(url)
      parse_response(response)
    end
  end
end