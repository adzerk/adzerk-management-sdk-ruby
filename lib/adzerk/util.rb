module Adzerk
  module Util
    extend self 

    def camelize_data(data)
      return data unless data.respond_to?(:reduce)
      data.reduce({}) do |acc, (sym, val)|
        acc[sym.to_s.camelize] = case val
                                   when Hash then camilize_data(val)
                                   when Array then val.map { |elem| camelize_data(elem) }
                                   else val
                                 end
        acc
      end
    end

    def uncamelize_data(data)
      # stop condition for the recursion
      return data unless data.respond_to?(:reduce)
      data.reduce({}) do |acc, (key, val)|
        acc[key.underscore.to_sym] = case val
                                       when Hash then uncamelize_data(val)
                                       when Array then val.map {|elem| uncamelize_data(elem) }
                                       else val
                                     end
        acc
      end
    end

    def parse_response(response)
      if response.code == "200"
        uncamelize_data(JSON.parse(response.body))
      elsif
        response
      end
    end
  end
end
