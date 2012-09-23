module Adzerk
  class Util
    def self.camelize_data(data)
      data.reduce({}) do |acc, (sym, val)|
        acc[sym.to_s.camelize] = val
        acc
      end
    end
  end
end
