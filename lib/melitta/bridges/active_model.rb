module Melitta::Bridges

  class ActiveModel

      attr_reader :resource

      def initialize(resource)
        @resource = resource
      end

      def form(filter)

        if filter.valid?
          form = resource.new(filter.output)
        else
          form = resource.new(filter.origin)
          traverse_error_messages(filter.errors, form)
          form.extend(InvalidInput)
        end

        form

      end

      def traverse_error_messages(messages, form)
        messages.each do |key, message|
          if message.is_a?(Hash)
            form_child = key.is_a?(Symbol) ? form.send(key.to_s.gsub(/_attributes/, '')) : form[key.to_i]
            traverse_error_messages(message, form_child)
          else
            form.errors.add(key, message)
          end
        end
      end

      module InvalidInput

        def update_attributes
          return false
        end

      end

    end


end
