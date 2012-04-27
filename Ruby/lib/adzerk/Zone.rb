require 'rest_client'

module Adzerk
  class Zone 
    
    def create(data={})
      uri = URI.parse($host + 'zone')
      data = { 'zone' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)        
      uri = URI.parse($host + 'zone/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'zone')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'zone/' + data["Id"].to_s)
      data = { 'zone' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + 'zone/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end