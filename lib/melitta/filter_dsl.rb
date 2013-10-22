class Melitta::FilterDsl

  attr_reader :receiver

  def self.evaluate type=Melitta::Filters::Tree, &block
    filter = new(type)
    filter.instance_eval &block
    filter.receiver
  end

  def initialize(receiver)
    @receiver = receiver.new
  end

  def keep field, coercer = String, &block
    if block_given?
      filter = evaluate(Melitta::Filters::Tree, block)
    else
      filter = Melitta::Filters::Base.new()
      filter.coercer = evaluate_coercer(coercer)
    end

    receiver.filter(field, filter)
  end

  def demand field, coercer = String, &block
    if block_given?
      filter = evaluate(Melitta::Filters::Tree, block)
      filter.required = true
    else
      filter = Melitta::Filters::Base.new
      filter.required = true
      filter.coercer = evaluate_coercer(coercer)
    end

    receiver.filter(field, filter)
  end

  def allow field, &block
    if block_given?
      filter = Melitta::Filters::PassThrough.new
      second_level_filter = evaluate(Melitta::Filters::Tree, block)
      filter.filter(field, second_level_filter)
    else
      filter = Melitta::Filters::PassThrough.new
    end

    receiver.filter(field, filter)
  end

protected

  def evaluate filter, block
    self.class.evaluate(filter, &block)
  end

  def evaluate_coercer coercer
    Melitta::Coercers.evaluate(coercer)
  end

end
