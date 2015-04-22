require "spec_helper"
require "attributes_mixin_helper"

RSpec.describe BayPhoto::Mixins::Attributes do
  let(:subject) { AttributesMixinHelper.new }

  before(:each) do
    AttributesMixinHelper.clear_attributes!
  end

  it "also extends the base class with ClassMethods when included" do
    expect(subject.class).to respond_to(:attribute)
    expect(subject).to respond_to(:update_attributes!)
    expect(subject).to respond_to(:defined_attributes)
  end

  it "has a helper method for getting the hash of defined attributes" do
    subject.class.attribute :foo, String
    expect(subject.defined_attributes).to eq(foo: String)
  end

  context ".attribute" do
    let(:subject) { AttributesMixinHelper }

    it "defines a new attribute on the model" do
      subject.attribute :foo, String
      obj = subject.new
      [:foo, :foo=].each { |sym| expect(obj).to respond_to(sym) }
    end

    it "does no coercion if the optional type argument is not supplied" do
      subject.attribute :foo
      obj = subject.new

      expect { obj.foo = 1 }.to change(obj, :foo).to(1)
      expect { obj.foo = "hello" }.to change(obj, :foo).to("hello")
      expect { obj.foo = :sym }.to change(obj, :foo).to(:sym)
      expect { obj.foo = 120.14 }.to change(obj, :foo).to(120.14)
    end

    it "coerces the input to the type specified" do
      test_struct = Struct.new(:input)
      expect(test_struct).to receive(:new).with("qwerty").and_call_original

      subject.attribute :foo, String
      subject.attribute :bar, Symbol
      subject.attribute :baz, test_struct
      subject.attribute :qux, Float

      obj = subject.new

      expect { obj.foo = 42 }.to change(obj, :foo).to("42")
      expect { obj.bar = "hello" }.to change(obj, :bar).to(:hello)
      expect { obj.qux = "100" }.to change(obj, :qux).to(100.0)
      obj.baz = "qwerty"
      expect(obj.baz).to be_a(test_struct)
      expect(obj.baz.input).to eq("qwerty")
    end

    it "registers the attribute in the hash" do
      subject.attribute :foo, Integer
      subject.attribute :bar, String
      obj = subject.new
      expect(obj.defined_attributes).to eq(foo: Integer, bar: String)
    end

    it "raises an error if unable to coerce the value" do
      test_struct = Class.new do
        def initialize(_a, _b, _c); end
      end
      subject.attribute :foo, test_struct

      obj = subject.new
      expect { obj.foo = 1 }.to raise_error do |e|
        expect(e).to be_a(BayPhoto::Exceptions::CoercionFailure)
        expect(e.message).to match(/Unable to coerce foo to .*Class/)
      end
    end
  end

  context "#update_attributes!" do
    before(:each) do
      AttributesMixinHelper.attribute :foo, String
      AttributesMixinHelper.attribute :bar, Integer
    end

    it "updates attributes passed in that are defined on the class" do
      expect(subject).to receive(:foo=).with("Hello")
      expect(subject).to receive(:bar=).with(12)
      subject.update_attributes! foo: "Hello", bar: 12
    end

    it "does not update attributes that are not defined on the class" do
      expect { subject.update_attributes! foo: "Hello", baz: 100 }.to_not raise_error
    end
  end
end

