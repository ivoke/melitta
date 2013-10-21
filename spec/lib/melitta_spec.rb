require_relative '../spec_helper'

describe Melitta do

  describe "Filter Module" do
    subject { Melitta.filter }

    it "should be a module" do
      subject.must_be_kind_of(Module)
    end

  end

  describe "Including a Filter Module" do

    subject { Class.new { include Melitta.filter } }

    it "should have a filter interface defined" do
      subject.must_respond_to(:filter)
    end

  end

end
