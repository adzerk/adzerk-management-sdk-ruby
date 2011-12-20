module Adzerk
  class Priority 
    
    def create(data={})
      uri = URI.parse($host + 'priority')
      data = { 'priority' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + 'priority/' + id.to_s)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'priority')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'priority/' + data["Id"].to_s)
      data = { 'priority' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + 'priority/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end

