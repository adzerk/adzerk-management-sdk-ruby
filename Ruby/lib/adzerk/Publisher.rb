module Adzerk
  class Publisher
    
    def create(data={})
      uri = URI.parse($host + '/publisher')
      data = { 'publisher' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + '/publisher/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + '/publisher')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + '/publisher/' + data["Id"].to_s + "/update")
      data = { 'publisher' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + '/publisher/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end