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

  end
end
