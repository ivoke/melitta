module Melitta::Filters

  class PassThrough < Base

    attr_reader :second_level_filter

    def run(params)
      if second_level_filter && params.respond_to?(:each)
        result(params)
      else
        params
      end
    end

    def filter(field, filter)
      @second_level_filter = filter
    end

  protected

    def result(params)
      result = params.each_with_object({}) do |(key, value), result|
        result[key] = second_level_filter.run(value)
      end

      ::Melitta::Coercers::Tree.new(result)
    end

  end

end
