module Adzerk
  class Campaign
    
    def create(data={})
      uri = URI.parse($host + '/campaign')
      data = { 'campaign' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + '/campaign/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + '/campaign')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + '/campaign/' + data["Id"].to_s + "/update")
      data = { 'campaign' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + '/campaign/' + id + '/delete')
      Adzerk.get_request(uri)
    end
    
  end
end