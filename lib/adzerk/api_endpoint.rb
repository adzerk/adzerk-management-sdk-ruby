module Adzerk
  class ApiEndpoint

    include Adzerk::Util

    attr_reader :client, :endpoint, :datakey, :subendpoint

    def initialize(args= {})
      @client = args[:client]
      @endpoint = args[:endpoint]
      @subendpoint = args[:subendpoint]
      @datakey = args[:datakey] ? args[:datakey] : args[:endpoint]
    end

    def create(opts={}, subid=nil)
      e = (subid && subendpoint) ? "#{subendpoint}/#{subid}/#{endpoint}" : endpoint
      data = { datakey => camelize_data(opts).to_json }
      response = @client.post_request(e, data)
      parse_response(response)
    end

    def get(id)
      response = @client.get_request("#{endpoint}/#{id}")
      parse_response(response)
    end

    def list(subid=nil, page: 1, pageSize: 500)
      e = (subid && subendpoint) ? "#{subendpoint}/#{subid}/#{endpoint}" : endpoint
      e = "#{e}?page=#{page}&pageSize=#{pageSize}"
      response = @client.get_request(e)
      parse_response(response)
    end

    def update(opts={})
      id = opts[:id].to_s
      data = { datakey => camelize_data(opts).to_json }
      response = @client.put_request("#{endpoint}/#{id}", data)
      parse_response(response)
    end

    def delete(id, subid=nil)
      e = (subid && subendpoint) ? "#{subendpoint}/#{subid}/#{endpoint}" : endpoint
      url = "#{e}/#{id}/delete"
      @client.get_request(url)
    end
  end
end
