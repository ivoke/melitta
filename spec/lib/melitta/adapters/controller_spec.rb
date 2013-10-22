require_relative '../../../spec_helper'

describe Melitta::Adapters::Controller do

  describe ".filter" do

    before(:each) do
      Object.const_set("User", Class.new do
        include ActiveModel
        def initialize(attributes); end
      end
      )
    end

    after(:each) do
      Object.send(:remove_const, "User")
    end

    subject do
      Class.new do
        extend Melitta::Adapters::Controller

        def params
          {
            :user => :value
          }
        end

        filter :user do; end
      end
    end

    it "sets a filter" do
      subject
        .class_variable_get("@@user_filter")
        .must_be_kind_of(Melitta::Filters::Tree)
    end

    it "defines a params method" do
      subject.new.must_respond_to(:user_params)
    end

    describe "virtual params methods" do

      it "returns a tree filter" do
        subject.new
          .send(:user_params)
          .must_be_kind_of(Melitta::Coercers::Tree)
      end

      it "filters the incoming params" do
        subject.new
          .send(:user_params)
          .output
          .must_be_empty
      end

    end

    it "defines a form method" do
      subject.new.must_respond_to(:user_form)
    end

    describe "virtual form methods" do

      it "returns a resource" do
        subject.new
          .send(:user_form)
          .must_be_kind_of(User)
      end

    end

  end

end
