module Adzerk
  class Flight
    
    def create(data={})
      uri = URI.parse($host + 'flight')
      data = { 'flight' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + 'flight/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'flight')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'flight/' + data["Id"].to_s)
      data = { 'flight' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + 'flight/' + id + '/delete')
      Adzerk.get_request(uri)
    end

    def countries()
      uri = URI.parse($host + 'countries')
      Adzerk.get_request(uri)
    end

    def regions(region)
      uri = URI.parse($host + 'regions/' + region)
      Adzerk.get_request(uri)
    end


  end
end