module Adzerk
    class Channel < ApiEndpoint
        def get_priorities(channel_id)
            url = "channel/#{channel_id}/priorities"
            response = client.get_request(url)
            parse_response(response)
        end
    end
end