module Adzerk
  class Invitation

    include Adzerk::Util

    attr_reader :client

    def initialize(args= {})
      @client = args[:client]
    end

    def invite_publisher(data={})
      data = { 'invitation' => camelize_data(data).to_json }
      @client.post_request('invite-publisher', data)
    end

    def invite_advertiser(data={})
      data = { 'invitation' => camelize_data(data).to_json }
      @client.post_request('invite-advertiser', data)
    end

  end
end
