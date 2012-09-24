require 'rest_client'

module Adzerk
  class Zone 

    include Adzerk::Util
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def create(data={})
      data = { 'zone' => camelize_data(data).to_json }
      response = client.post_request('zone', data)
      parse_response(response)
    end
    
    def get(id)        
      url = 'zone/' + id
      response = client.get_request(url)
      parse_response(response)
    end
    
    def list
      response = client.get_request('zone')
      parse_response(response)
    end
    
    def update(data={})
      url = 'zone/' + data[:id].to_s
      data = { 'zone' => camelize_data(data).to_json }
      response = client.put_request(url, data)
      parse_response(response)
    end
    
    def delete(id)
      url = 'zone/' + id + '/delete'
      client.get_request(url)
    end
  end
end
