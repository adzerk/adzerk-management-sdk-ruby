module Adzerk
  class EntityCounts
    include Adzerk::Util

    def initialize(args={})
      @client = args[:client]
    end

    def entity_counts(date=nil)
      url = "entitycounts"
      unless date.nil?
        url = "#{url}?date=#{date}"
      end
      response = @client.get_request(url)
      parse_response(response)
    end

  end
end
