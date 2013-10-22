require 'active_support/core_ext/object/blank'
require 'active_model/naming'
require 'melitta/version'
require 'melitta/filter_dsl'
require 'melitta/adapters'
require 'melitta/bridges'
require 'melitta/filters'
require 'melitta/coercers'

module Melitta

  def self.filter
    Adapters
  end

end

