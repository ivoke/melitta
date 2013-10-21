module Melitta::Bridges

  module Base

    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def filter field, &block
        filter = Melitta::FilterDsl.evaluate(Melitta::Filters::Tree, &block)
        class_variable_set("@@#{field}_filter", filter)

        define_method :"#{field}_filter" do |params|
          filter.run(params.fetch(field, {}))
        end
      end

    end

  end

end
