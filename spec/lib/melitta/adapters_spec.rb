require_relative '../../spec_helper'

describe Melitta::Adapters do

  describe ".included" do

    describe "default" do

      subject do
        Class.new { include Melitta.filter }
      end

      it "includes the Adapter" do
        subject
          .included_modules
          .must_include(Melitta::Adapters)
      end

      it "extends the Base Adapter" do
        subject
          .singleton_class
          .included_modules
          .must_include(Melitta::Adapters::Base)
      end

    end

    describe "in ActionControllers" do

      before(:each) do
        Object.const_set("ActionController", Module.new)
        ActionController.const_set("Base", Class.new)
      end

      after(:each) do
        Object.send(:remove_const, "ActionController")
      end

      subject do
        Class.new(ActionController::Base) { include Melitta.filter }
      end

      it "includes the Adapter" do
        subject
          .included_modules
          .must_include(Melitta::Adapters)
      end

      it "extends the Controller Adapter" do
        subject
          .singleton_class
          .included_modules
          .must_include(Melitta::Adapters::Controller)
      end

    end

  end

end
