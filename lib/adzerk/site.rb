module Adzerk
    class Site < ApiEndpoint
        def filter_sites(data={})
            query_string = URI.encode_www_form(data)
            url = "fast/site?#{query_string}"
            @client.filter(url)
        end
    end
end