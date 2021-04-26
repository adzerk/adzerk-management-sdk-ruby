module Adzerk
    class ScheduledReporting < ApiEndpoint
        def create_scheduled_reports()
            url = "report/schedule"
            parse_response(@client.post_request(url, camelize_data(data)))
        end
    end
end