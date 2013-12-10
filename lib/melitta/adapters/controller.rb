module Melitta::Adapters

  module Controller

    def filter selector, resource=selector, prefix=nil, &block
      selector = infer_selector(selector)
      resource = infer_resource_name(resource)
      prefix   = prefix || selector

      filter = Melitta::FilterDsl.evaluate(&block)
      class_variable_set(:"@@#{prefix}_filter", filter)

      class_eval <<-RUBY
         def #{prefix}_params
          @#{prefix}_params ||= begin
            filter = self.class.class_variable_get(:"@@#{prefix}_filter")
            filter.run(params.fetch(:"#{selector}", {}))
          end
        end
        protected :"#{prefix}_params"
      RUBY

      class_eval <<-RUBY
         def #{prefix}_form
          @#{prefix}_form ||= begin
            Melitta::Bridges::ActiveModel.new(#{resource}).form(#{prefix}_params)
          end
        end
        protected :"#{prefix}_form"
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
