module Adzerk
    class ScheduledReporting < ApiEndpoint
        def create(data)
            url = "report/schedule"
            formatted_data = data.transform_keys{ |key| key.downcase }
            parse_response(@client.post_json_request(url, camelize_data(formatted_data)))
        end

        def get(report_id)
            url = "report/schedule/#{report_id}"
            parse_response(@client.get_request(url))
        end

        def list()
            url = "report/schedule"
            parse_response(@client.get_request(url))
        end

        def delete(report_id)
            url = "report/schedule/#{report_id}/delete"
            parse_response(@client.get_request(url))
        end
    end
end
