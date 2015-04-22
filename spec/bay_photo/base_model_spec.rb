require "spec_helper"
require "bay_photo/base_model"

RSpec.describe BayPhoto::BaseModel do
  it "includes the HTTP mixin" do
    expect(subject).to respond_to(:get)
    expect(subject).to respond_to(:post)
  end

  it "includes the Attributes mixin" do
    expect(described_class).to respond_to(:attribute)
    expect(subject).to respond_to(:update_attributes!)
  end

  it "calls #update_attributes! on initialize" do
    expect_any_instance_of(described_class).to receive(:update_attributes!).with(foo: "bar")
    described_class.new foo: "bar"
  end

  it "has a DSL method for setting the default resource path" do
    expect(described_class).to respond_to(:resource)
    described_class.resource :foo
    expect(subject.resource).to eq(:foo)
  end

  it "is able to fetch the full list of models from the API" do
    described_class.resource :foo
    described_class.attribute :hello

    expect(described_class).to respond_to(:all)
    expect_any_instance_of(described_class).to receive(:get).with(resource: :foo).and_return([{ hello: "world" },
                                                                                              { hello: "josh" },
                                                                                              { hello: "pants" }])

    models = described_class.all
    expect(models).to be_an(Array)
    expect(models).to be_all { |obj| obj.is_a? described_class }
    expect(models.find { |mod| mod.hello == "pants" }).not_to be_nil
  end
end

