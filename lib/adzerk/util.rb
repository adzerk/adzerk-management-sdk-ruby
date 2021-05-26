module Adzerk
  module Util
    extend self

    def camelize_data(data)
      return data unless data.respond_to?(:reduce)
      data.reduce({}) do |acc, (sym, val)|
        sym = sym.to_s.camelize if sym.class == Symbol
        acc[sym] = case val
                     when Hash then camelize_data(val)
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
        acc[/[a-zA-Z]/.match?(key) ? key.underscore.to_sym : key] = case val
                                       when Hash then uncamelize_data(val)
                                       when Array then val.map {|elem| uncamelize_data(elem) }
                                       else val
                                     end
        acc
      end
    end

    def parse_response(response)
      parsed_body = JSON.parse(response.body)
      case parsed_body
        when Hash then uncamelize_data(parsed_body)
        when Array then parsed_body.map {|elem| uncamelize_data(elem)}
        else parsed_body
      end
    end
  end
end
