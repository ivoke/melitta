module Melitta::Coercers

  def self.evaluate(coercer)
    coercer = coercer.is_a?(Class) ? coercer.name : coercer
    "Melitta::Coercers::#{coercer}".constantize
  end

  Identity = Struct.new(:input) do

    def valid?
      true
    end

    def output
      input
    end

  end

  String = Struct.new(:input) do

    def valid?
      true
    end

    def output
      input.to_s
    end

  end

  Integer = Struct.new(:input) do

    def valid?
      !! /\A\d*\z/.match(input)
    end

    def output
      input.to_i
    end

  end

  Float = Struct.new(:input) do

    def valid?
      !! /\A\d+([,.]\d+)?\z/.match(input)
    end

    def output
      output = input
      output = input.gsub(',', '.') if /(\d)*,(\d)*/.match(input)
      output.to_f
    end

  end

  Boolean = Struct.new(:input) do

    def valid?
      input.blank? || input =~ (/\A(true|1|false|0)\z/i)
    end

    def output
      (input =~ (/(true|1)$/i)) === 0
    end

  end

  Date = Struct.new(:input) do

    def valid?
      # valid formats are
      # day[.-/]month[.-/]year or year[.-/]month[.-/]day
      # year has to be 4 digits, due to Date.parse misinterpreting ambiguous values, e.g. "26.02.13" as Feb 13th 2026
      # month [01-12] and day [01-31] can be single or double digits
      if !! /\A((?:\d{4}[-.\/](0?[1-9]|1[012])[-.\/](0?[1-9]|[12][0-9]|3[01]))|(?:(0?[1-9]|[12][0-9]|3[01])[-.\/](0?[1-9]|1[012])[-.\/]\d{4}))\z/.match(input)
        begin
          ::Date.parse(input)
        rescue ArgumentError
          return false
        end
        return true
      else
        return false
      end
    end

    def output
      ::Date.parse(input)
    end

  end

  MonthYear = Struct.new(:input) do
    # valid formats are
    # month[.-/]year or year[.-/]month
    # year has to be 4 digits to force unambiguity
    def valid?
      !! /\A((?:\d{4}[-.\/](0?[1-9]|1[012]))|(?:(0?[1-9]|1[012])[-.\/]\d{4}))\z/.match(input)
    end

    def output
      month = input.scan(/\b(?:0?[1-9]|1[012])\b/)[0].to_i
      year  = input.scan(/\b\d{4}\b/)[0].to_i

      ::Date.new(year, month)
    end

  end

  Tree = Struct.new(:input) do

    def origin
      input.each_with_object({}) do |(k,v), hsh|
        hsh[k] = v.respond_to?(:origin) ? v.origin : v.input
      end
    end

    def errors
      input.each_with_object({}) do |(k,v), hsh|
        unless v.valid?
          hsh[k] = v.respond_to?(:errors) ? v.errors : I18n.t("errors.coercers.#{v.class.name.demodulize.downcase}")
        end
      end
    end

    def valid?
      input.all? { |k,v| v.valid? }
    end

    def output
      input.each_with_object({}) do |(k,v), hsh|
        hsh[k] = v.output
      end
    end

  end

  MissingInput = Struct.new(:input) do

    def errors
      I18n.t("errors.coercers.missing_input")
    end

    def valid?
      false
    end

    def output
      input
    end

  end

  OptionalInput = Struct.new(:input) do

    def valid?
      true
    end

    def output
      input
    end

  end

end
