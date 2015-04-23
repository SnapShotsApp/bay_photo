require "spec_helper"
require "bay_photo/enum"

RSpec.describe BayPhoto::Enum do
  it { should respond_to(:define) }

  context ".define" do
    it "returns a new EnumInstance class" do
      enum = subject.define(:foo)
      expect(enum).to be_a(Class)
      expect(enum.ancestors).to include(subject::EnumInstance)
    end

    it "sets the args and start_at class-instance vars on the new class" do
      enum = subject.define(:foo, :bar, start_at: 8)
      expect(enum.instance_variable_get(:@args)).to match_array([:foo, :bar])
      expect(enum.instance_variable_get(:@start_at)).to equal(8)
    end

    it "raises an error if the args list is empty" do
      expect { subject.define(start_at: 0) }.to raise_error do |e|
        expect(e).to be_a(RuntimeError)
        expect(e.message).to eq("Must have at least one symbol in args list")
      end
    end

    it "raises an error if the args list contains non-Symbols" do
      expect { subject.define("foo", :bar) }.to raise_error do |e|
        expect(e).to be_a(RuntimeError)
        expect(e.message).to eq("All args must be Symbols")
      end
    end
  end

  context "::EnumInstance" do
    before(:each) do
      @enum = described_class.define(:foo, :bar, :baz, start_at: 5).new(:baz)
    end

    let(:subject) { @enum }

    it { should respond_to(:args) }
    it { should respond_to(:start_at) }
    it { should respond_to(:value) }

    it "returns the value of the class-instance variables in accessors" do
      expect(subject.args).to match_array([:foo, :bar, :baz])
      expect(subject.start_at).to be 5
    end

    it "contains the value of the Enum correspondance" do
      expect(subject.value).to be 7
    end

    context "#initialize" do
      let(:subject) { described_class.define(:foo, :bar, start_at: 1) }

      it "raises an error if the symbol argument is out of bounds" do
        expect { subject.new(:baz) }.to raise_error do |e|
          expect(e).to be_a(RuntimeError)
          expect(e.message).to eq("Enum out of bounds: baz")
        end
      end

      it "raises an error if the integer argument is out of bounds" do
        expect { subject.new(4) }.to raise_error do |e|
          expect(e).to be_a(RuntimeError)
          expect(e.message).to eq("Enum out of bounds: 4")
        end
      end

      it "raises an error if the input is not an integer or symbol" do
        expect { subject.new("pants") }.to raise_error do |e|
          expect(e).to be_a(RuntimeError)
          expect(e.message).to eq("Invalid Enum input: pants")
        end
      end

      it "sets the value to the correspondance" do
        enum = subject.new(:bar)
        expect(enum.value).to be 2

        enum = subject.new(1)
        expect(enum.value).to be :foo
      end
    end
  end
end

