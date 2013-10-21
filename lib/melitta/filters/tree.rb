module Melitta::Filters

  class Tree < Base

    attr_reader :filters

    def initialize
      @filters = {}
    end

    def filter field, filter
      filters[field] = filter
    end

  protected

    def result(params)
      result = filters.each_with_object({}) do |(field, filter), result|
        result[field] = filter.run(params.fetch(field, ""))
      end

      ::Melitta::Coercers::Tree.new(result)
    end

  end

end
