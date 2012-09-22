module Adzerk
  class ChannelSiteMap
    
    def create(data={})
      uri = URI.parse($host + 'channelSite')
      data = { 'channelSite' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
    def get(channelId, siteId)
      uri = URI.parse($host + 'channel/' + channelId.to_s + '/site/' + siteId.to_s)
      Adzerk.get_request(uri)
    end
    
    def list()
      uri = URI.parse($host + 'channelSite')
      response = Adzerk.get_request(uri)
      JSON.parse(response.body)
    end
    
    def update(data={})
      uri = URI.parse($host + 'channelSite')
      data = { 'channelSite' => data.to_json }
      Adzerk.put_request(uri, data)
    end
    
    def delete(channelId, siteId)
      uri = URI.parse($host + 'channel/' + channelId.to_s + '/site/'+ siteId.to_s + '/delete')
      Adzerk.get_request(uri)
    end

    def sitesInChannel(channelId)
      uri = URI.parse($host + 'sitesInChannel/' + channelId.to_s)
      Adzerk.get_request(uri)      
    end

    def channelsInSite(siteId)
      uri = URI.parse($host + 'channelsInSite/' + siteId.to_s)
      Adzerk.get_request(uri)
    end

  end
end

