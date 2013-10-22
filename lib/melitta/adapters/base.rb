module Melitta::Adapters

  module Base

    def filter field, &block
      filter = Melitta::FilterDsl.evaluate(&block)
      class_variable_set("@@#{field}_filter", filter)

      define_method :"#{field}_filter" do |params|
        filter.run(params.fetch(field, {}))
      end
    end

  end

end
