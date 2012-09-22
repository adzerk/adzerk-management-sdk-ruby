require 'rest_client'

module Adzerk
  class Site
    class << self

      def create(data={})
        uri = URI.parse($host + 'site')
        data = { 'site' => data.to_json }
        Adzerk.post_request(uri, data)
      end

      def get(id)
        uri = URI.parse($host + 'site/' + id)
        Adzerk.get_request(uri)
      end

      def list()
        uri = URI.parse($host + 'site')
        response = Adzerk.get_request(uri)
        JSON.parse(response.body)
      end

      def update(data={})
        uri = URI.parse($host + 'site/' + data["Id"].to_s)
        data = { 'site' => data.to_json }
        Adzerk.put_request(uri, data)
      end

      def delete(id)
        uri = URI.parse($host + 'site/' + id + '/delete')
        Adzerk.get_request(uri)
      end

    end
  end
end
