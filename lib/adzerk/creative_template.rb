module Adzerk
  class CreativeTemplate

    include Adzerk::Util

    attr_reader :client

    def initialize(args={})
      @client = args[:client]
    end

    def create(data={})
      parse_response(@client.post_json_request("creative-templates", version: 'v2'), data)
    end

    def update(id, data={})
      url = "creative-templates/#{id}/update"
      parse_response(@client.post_json_request(url, data, version: 'v2'))
    end

    def get(id)
      parse_response(@client.get_request("creative-templates/#{id}", 'v2'))
    end

    def list(id, page: 1, pageSize: 500)
      url = "creative-templates?page=#{page}&pageSize=#{pageSize}"
      parse_response(@client.get_request(url, version: 'v2'))
    end
  end
end