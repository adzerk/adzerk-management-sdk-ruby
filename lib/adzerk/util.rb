module Adzerk
  class Util
    def self.camelize_data(data)
      data.reduce({}) do |acc, (sym, val)|
        acc[sym.to_s.camelize] = val
        acc
      end
    end

    def self.uncamelize_data(data)
      data.reduce({}) do |acc, (key, val)|
        acc[key.underscore.to_sym] = case val
                                       when Hash then uncamelize_data(val)
                                       when Array then val.map {|elem| uncamelize_data(elem) }
                                       else val
                                     end
        acc
      end
    end

    def self.parse_response(response)
      if response.code == "200"
        Adzerk::Util.uncamelize_data(JSON.parse(response.body))
      elsif
        response
      end
    end
  end
end
