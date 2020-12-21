module Adzerk
  class Publisher < ApiEndpoint

    def earnings(data={})
      data = { 'earnings' => camelize_data(data).to_json }
      response = @client.post_request('/earnings', data)
      parse_response(response)
    end

    def payments(data={})
      data = { 'payments' => camelize_data(data).to_json }
      response = @client.post_request('/payments', data)
      parse_response(response)
    end

    def create(opts={}, subid=nil)
      e = (subid && subendpoint) ? "#{subendpoint}/#{subid}/#{endpoint}" : endpoint
      data = { datakey => camelize_data(opts).to_json }
      response = @client.post_request(e, data)
      parse_response(response)
    end

    def update(opts={})
      id = opts[:id].to_s
      data = { datakey => camelize_data(opts).to_json }
      response = @client.put_request("#{endpoint}/#{id}", data)
      parse_response(response)
    end

  end
end
