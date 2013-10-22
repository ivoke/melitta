require_relative './adapters/base'
require_relative './adapters/controller'

module Melitta

  module Adapters

    def self.included(base)

      if base.ancestors.map(&:name).include?('ActionController::Base')
        base.send :extend, Melitta::Adapters::Controller
      else
        base.send :extend, Melitta::Adapters::Base
      end

    end

  end

end
