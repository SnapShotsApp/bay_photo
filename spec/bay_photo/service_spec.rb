require "spec_helper"

RSpec.describe BayPhoto::Service do
  EXPECTED_ATTRIBUTES = %i[id name service_type]
  EXPECTED_ATTRIBUTES.each do |attr|
    it { should respond_to(attr) }
    it { should respond_to(:"#{attr}=") }
  end

  it "should define the correct resource" do
    expect(subject.resource).to eq(:services)
  end
end

