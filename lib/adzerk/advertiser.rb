module Adzerk
  class Advertiser
    
    def create(data={})
      uri = URI.parse($host + 'advertiser')
      data = { 'advertiser' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + 'advertiser/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'advertiser')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'advertiser/' + data["Id"].to_s)
      data = { 'advertiser' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(id)
      uri = URI.parse($host + 'advertiser/' + id.to_s + '/delete')
      Adzerk.get_request(uri)
    end

    def search(advertiserName)
      uri = URI.parse($host + 'advertiser/search')
      data = { 'advertiserName' => advertiserName }
      Adzerk.post_request(uri, data)      
    end

  end
end