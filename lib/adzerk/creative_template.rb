module Adzerk
  class CreativeTemplate

    include Adzerk::Util

    attr_reader :client

    def initialize(args={})
      @client = args[:client]
    end

    def create(data={})
      parse_response(@client.post_json_request("creative-templates", camelize_data(data), version: 'v2'))
    end

    def update(id, data={})
      url = "creative-templates/#{id}/update"
      parse_response(@client.post_json_request(url, camelize_data(data), version: 'v2'))
    end

    def get(id)
      parse_response(@client.get_request("creative-templates/#{id}", version: 'v2'))
    end

    def list(page: 1, pageSize: 100, includeArchived: false)
      url = "creative-templates?page=#{page}&pageSize=#{pageSize}&includeArchived=#{includeArchived}"
      parse_response(@client.get_request(url, version: 'v2'))
    end
  end
end
