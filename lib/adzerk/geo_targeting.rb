module Adzerk
  class GeoTargeting

    include Adzerk::Util

    def initialize(args={})
      @client = args[:client]
    end

    def create(flight_id, data={})
      url = "flight/#{flight_id}/geotargeting"
      data = { 'geotargeting' => camelize_data(data).to_json }
      parse_response(@client.post_request(url, data))
    end

    def get(flight_id, id)
      url = "flight/#{flight_id}/geotargeting/#{id}"
      parse_response(@client.get_request(url))
    end

    def update(flight_id, id, data={})
      url = "flight/#{flight_id}/geotargeting/#{id}"
      data = { 'geotargeting' => camelize_data(data).to_json }
      parse_response(@client.put_request(url, data))
    end

    def delete(flight_id, id)
      url = "flight/#{flight_id}/geotargeting/#{id}/delete"
      @client.get_request(url)
    end
  end
end