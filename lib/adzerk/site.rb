require 'rest_client'

module Adzerk
  class Site

    def initialize(client)
      @client = client
    end

    def create(opts={})
      data = { 'site' => Adzerk::Util.camelize_data(opts).to_json }
      @client.post_request('site', data)
    end

    def get(id)
      @client.get_request('site/' + id)
    end

    def list
      response = @client.get_request('site')
      JSON.parse(response.body)
    end

    def update(opts={})
      id = opts[:id].to_s
      data = { 'site' => Adzerk::Util.camelize_data(opts).to_json }
      @client.put_request('site/' + id, data)
    end

    def delete(id)
      url = 'site/' + id + '/delete'
      @client.get_request(url)
    end
  end
end
