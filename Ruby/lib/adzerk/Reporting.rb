module Adzerk
  class Reporting
    
    def create_report(data={})
      uri = URI.parse($host + 'report')
      data = { 'criteria' => data.to_json }
      Adzerk.post_request(uri, data)
    end

    def get(id)
      uri = URI.parse($host + 'report/' + id)
      Adzerk.get_request(uri)
    end

  end
end
