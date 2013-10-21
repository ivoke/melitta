require 'active_support/core_ext/object/blank'
require 'melitta/version'
require 'melitta/filter_dsl'
require 'melitta/bridges'
require 'melitta/filters'
require 'melitta/coercers'

module Melitta

  def self.filter
    Bridges::Base
  end

end

