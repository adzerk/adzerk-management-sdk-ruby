module Adzerk
  class Reporting
    
    def create_report(data={})
      uri = URI.parse($host + 'report')
      data = { 'criteria' => data.to_json }
      Adzerk.post_request(uri, data)
    end
    
  end
end