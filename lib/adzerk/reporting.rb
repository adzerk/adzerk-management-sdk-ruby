module Adzerk
  class Reporting
    include Adzerk::Util

    attr_accessor :client

    def initialize(args = {})
      @client = args.fetch(:client)
    end

    def create_report(data={})
      data = { 'criteria' => camelize_data(data).to_json }
      parse_response(client.post_request('report', data))
    end

    def retrieve_report(id)
      url = 'report/' + id
      client.get_request(url)
    end
  end
end
