module Adzerk
  class Login
    
    def create(data={})
      uri = URI.parse($host + 'login')
      data = { 'login' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(id)
      uri = URI.parse($host + 'login/' + id)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'login')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'login/' + data["Id"].to_s)
      data = { 'login' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
  end
end