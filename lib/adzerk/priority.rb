module Adzerk
  class Priority < ApiEndpoint
    def create(opts={})
      opts[:selection_algorithm] ||= 0 # SelectionAlgorithm defaults to 0 (Lottery)
      super opts
    end
  end
end
