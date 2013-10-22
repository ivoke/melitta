module Melitta::Adapters

  module Controller

    def filter selector, resource=selector, &block
      selector = infer_selector(selector)
      resource = infer_resource_name(resource)

      filter = Melitta::FilterDsl.evaluate(&block)
      class_variable_set(:"@@#{selector}_filter", filter)

      class_eval <<-RUBY
         def #{selector}_params
          @#{selector}_params ||= begin
            filter = self.class.class_variable_get(:"@@#{selector}_filter")
            filter.run(params.fetch(:"#{selector}", {}))
          end
        end
        protected :"#{selector}_params"
      RUBY

      class_eval <<-RUBY
         def #{selector}_form
          @#{selector}_form ||= begin
            Melitta::Bridges::ActiveModel.new(#{resource}).form(#{selector}_params)
          end
        end
        protected :"#{selector}_form"
      RUBY

    end

  private

    def infer_selector resource_or_key
      if resource_or_key.respond_to?(:model_name)
        ActiveModel::Naming.param_key(resource_or_key)
      else
        resource_or_key
      end
    end

    def infer_resource_name resource_or_key
      if resource_or_key.is_a?(Class)
        resource_or_key.name
      else
        resource_or_key.to_s.classify
      end
    end

  end


end
