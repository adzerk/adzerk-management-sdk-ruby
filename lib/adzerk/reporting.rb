module Adzerk
  class Reporting
    include Adzerk::Util

    attr_accessor :client

    REPORT_STATUS = {
      success: 2
    }

    def initialize(args = {})
      @client = args.fetch(:client)
    end

    # Queues a report and then polls for it using exponential backoff, blocking
    # until the report is either retrieved or (optionally) if a timeout is
    # exceeded.
    #
    # The timeout is a total number of milliseconds to wait before giving up
    # and raising an error.
    #
    # If no timeout is provided, this function will continue to poll forever
    # with exponential backoff.
    #
    # Returns the parsed report JSON when a report is retrieved.
    def create_report(data={}, timeout=nil)
      # Queue the report.
      queue_response = create_queued_report(data)

      # Ensure it contains a report ID.
      report_id = queue_response[:id]
      raise "Unexpected response: #{queue_response}" unless report_id

      # Try to get the report indefinitely or up until the timeout, with
      # exponential backoff.
      time_to_stop  = Time.now + (timeout / 1000.0) unless timeout.nil?
      retries = 0

      while timeout.nil? or Time.now < time_to_stop
        poll_result = retrieve_queued_report(report_id)

        if poll_result[:status] == REPORT_STATUS[:success]
          return poll_result[:result]
        end

        poll_interval = (2 ** retries) * 100
        sleep poll_interval / 1000.0

        retries += 1
      end

      raise "Failed to retrieve report within #{timeout} ms."
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
