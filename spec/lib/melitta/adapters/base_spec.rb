require_relative '../../../spec_helper'

describe Melitta::Adapters::Base do

  describe ".filter" do

    before(:each) do
      subject.filter :field do; end
    end

    subject do
      Class.new { extend Melitta::Adapters::Base }
    end

    it "sets a filter" do
      subject
        .class_variable_get("@@field_filter")
        .must_be_kind_of(Melitta::Filters::Tree)
    end

    it "has a filter method defined" do
      subject.new.must_respond_to(:field_filter)
    end

    it "returns an optional input coercer" do
      subject.new
        .field_filter({})
        .must_be_kind_of(Melitta::Coercers::OptionalInput)
    end

    it "filters" do
      subject.new
        .field_filter({})
        .output
        .must_be_empty
    end

  end

end
