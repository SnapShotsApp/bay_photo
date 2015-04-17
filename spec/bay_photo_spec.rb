require "spec_helper"

RSpec.describe BayPhoto do
  it { should be_a(Module) }
  it { should respond_to(:configure) }

  it "is configurable with a yield method" do
    subject.configure do |config|
      expect(config).to be(BayPhoto::Configuration)
      config.access_token = "abc123"
    end

    expect(BayPhoto::Configuration.access_token).to eq("abc123")
  end
end

