module Adzerk
  class CreativeTemplate

    include Adzerk::Util

    attr_reader :client

    def initialize(args={})
      @client = Adzerk::Client.new(args[:key], :host => 'https://api.adzerk.net/v2/', :include_creative_templates => false)
    end

    def create(data={})
      parse_response(@client.post_json_request("creative-templates"), data)
    end

    def update(id, data={})
      url = "creative-templates/#{id}/update"
      parse_response(@client.post_json_request(url, data))
    end

    def get(id)
      parse_response(@client.get_request("creative-templates/#{id}"))
    end

    def list(id, page: 1, pageSize: 500)
      url = "creative-templates?page=#{page}&pageSize=#{pageSize}"
      parse_response(@client.get_request(url))
    end
  end
end