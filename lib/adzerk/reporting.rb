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

    def create_queued_report(data={})
      data = { 'criteria' => camelize_data(data).to_json }
      parse_response(client.post_request('report/queue', data))
    end

    def retrieve_queued_report(id)
      url = 'report/queue/' + id
      parse_response(client.get_request(url))
    end
  end
end
