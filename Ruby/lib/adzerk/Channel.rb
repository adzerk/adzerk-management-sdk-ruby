module Adzerk
  class Channel
    
    def create(data={})
      uri = URI.parse($host + 'channel')
      data = { 'channel' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + '/channel/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + '/channel')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + '/channel/' + data["Id"].to_s + "/update")
      data = { 'channel' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + '/channel/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end