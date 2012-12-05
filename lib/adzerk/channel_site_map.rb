module Adzerk
  class ChannelSiteMap

    include Adzerk::Util

    attr_reader :client

    def initialize(args= {})
      @client = args[:client]
    end

    def create(data={})
      data = { 'channelSite' => camelize_data(data).to_json }
      response = client.post_request('channelSite', data)
      parse_response(response)
    end

    def get(channel_id, site_id)
      url = "channel/#{channel_id}/site/#{site_id}"
      response = client.get_request(url)
      response = parse_response(response)
    end

    def list
      response = client.get_request('channelSite')
      parse_response(response)
    end

    def update(data={})
      data = { 'channelSite' => camelize_data(data).to_json }
      response = client.put_request('channelSite', data)
      parse_response(response)
    end

    def delete(channel_id, site_id)
      url = "channel/#{channel_id}/site/#{site_id}/delete"
      client.get_request(url)
    end

    def sites_in_channel(channel_id)
      url = "sitesInChannel/#{channel_id}"
      response = client.get_request(url)
      parse_response(response)
    end

    def channels_in_site(site_id)
      url = "channelsInSite/#{site_id}"
      response = client.get_request(url)
      parse_response(response)
    end
  end
end

