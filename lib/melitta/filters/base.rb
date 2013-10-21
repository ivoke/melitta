module Melitta::Filters

  class Base

    attr_accessor :required, :coercer

    def run(params)
      if required && params.blank?
        return ::Melitta::Coercers::MissingInput.new(params)
      elsif !required && params.blank?
        return ::Melitta::Coercers::OptionalInput.new(params)
      else
        result(params)
      end
    end

  protected

    def result(params)
      coercer.new(params)
    end

  end

end
