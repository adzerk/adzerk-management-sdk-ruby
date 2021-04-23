module Adzerk
    class DayParting < ApiEndpoint
        def create(flight_id, data={})
            url = "flight/#{flight_id}/dayparting"
            parse_response(@client.post_json_request(url, camelize_data(data)))
        end

        def get(flight_id, timepart_id)
            url = "flight/#{flight_id}/dayparting/#{timepart_id}"
            parse_response(@client.get_request(url))
        end

        def list(flight_id)
            url = "flight/#{flight_id}/dayparting"
            parse_response(@client.get_request(url))
        end

        def delete(flight_id, timepart_id)
            url = "flight/#{flight_id}/dayparting/#{timepart_id}/delete"
            @client.post_request(url, data={})
        end
    end
end