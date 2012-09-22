require "rest_client"

module Adzerk
  class Creative
    
    def create(data={}, imagepath='')      
      response = RestClient.post $host + 'creative',
        {:creative => data.to_json},
        :X_Adzerk_ApiKey => Adzerk.api_key,
        :content_type => :json, 
        :accept => :json
        
      Adzerk.uploadCreative(JSON.parse(response)["Id"], imagepath) 
    end
    
    def get(id)
      uri = URI.parse($host + 'creative/' + id)
      Adzerk.get_request(uri)
    end
    
    def list(advertiserId)
      uri = URI.parse($host + 'advertiser/' + advertiserId.to_s + "/creatives")
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