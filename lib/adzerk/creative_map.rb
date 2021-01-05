module Adzerk
  class CreativeMap

    include Adzerk::Util

    def initialize(args={})
      @client = args[:client]
    end

    def create(data={})
      url = "flight/#{data[:flight_id]}/creative"
      data = { 'creative' => camelize_data(data).to_json }
      parse_response(@client.post_request(url, data))
    end

    def get(id, flight_id)
      url = "flight/#{flight_id}/creative/#{id}"
      parse_response(@client.get_request(url))
    end

    def list(flight_id, page: 1, pageSize: 500)
      url = "flight/#{flight_id}/creatives?page=#{page}&#pageSize=#{pageSize}"
      parse_response(@client.get_request(url))
    end

    def update(data={})
      url = "flight/#{data[:flight_id]}/creative/#{data[:id]}"
      data = { 'creative' => camelize_data(data).to_json }
      parse_response(@client.put_request(url, data))
    end

    def delete(id, flight_id)
      url = "flight/#{flight_id}/creative/#{id}/delete"
      @client.get_request(url)
    end

    def instant_counts(creative_map_id)
      url = "instantcounts/#{endpoint}/#{creative_map_id}"
      parse_response(client.get_request(url))
    end

  end
end
