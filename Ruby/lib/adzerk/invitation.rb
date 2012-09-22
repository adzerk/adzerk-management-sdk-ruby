module Adzerk
  class Invitation

    def invite_publisher(data={})
      uri = URI.parse($host + 'invite-publisher')
      data = { 'invitation' => data.to_json }
      Adzerk.post_request(uri, data)
    end

    def invite_advertiser(data={})
      uri = URI.parse($host + 'invite-advertiser')
      data = { 'invitation' => data.to_json }
      Adzerk.post_request(uri, data)
    end

  end
end