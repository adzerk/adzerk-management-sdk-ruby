module Adzerk
    class Channel < ApiEndpoint
        def get_priorities(channel_id)
            url = "channel/#{channel_id}/priorities"
            client.get_request(url)
        end
    end
end