module Adzerk
  class Creative
    
    def create(data={})
      uri = URI.parse($host + 'creative')
      data = { 'creative' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + 'creative/' + id)
      Adzerk.get_request(uri)
    end
    
    def list(flightId)
      uri = URI.parse($host + 'flight/' + flightId.to_s + "/creatives")
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'creative/' + data["Id"].to_s)
      data = { 'creative' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + 'creative/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end