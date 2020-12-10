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
        acc[key.underscore.to_sym] = case val
                                       when Hash then uncamelize_data(val)
                                       when Array then val.map {|elem| uncamelize_data(elem) }
                                       else val
                                     end
        acc
      end
    end

    def parse_response(response)
      uncamelize_data(JSON.parse(response.body)).to_dot.with_indifferent_access
    end
  end
end
