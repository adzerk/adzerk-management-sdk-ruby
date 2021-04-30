module Adzerk
    class DistanceTargeting < ApiEndpoint
        def create(flight_id, data={})
            url = "flight/#{flight_id}/distance"
            parse_response(@client.post_json_request(url, camelize_data(data)))
        end

        def batch_upload(flight_id, data={})
            url = "flight/#{flight_id}/distance/batch"
            parse_response(@client.post_json_request(url, camelize_data(data)))
        end

        def update(flight_id, geometry_id, data={})
            url = "flight/#{flight_id}/distance/#{geometry_id}"
            parse_response(@client.put_json_request(url, camelize_data(data)))
        end

        def get(flight_id, geometry_id)
            url = "flight/#{flight_id}/distance/#{geometry_id}"
            parse_response(@client.get_request(url))
        end

        def list(flight_id)
            url = "flight/#{flight_id}/distance"
            parse_response(@client.get_request(url))
        end

        def delete(flight_id, geometry_id)
            url = "flight/#{flight_id}/distance/#{geometry_id}"
            @client.delete_request(url)
        end
    end
end