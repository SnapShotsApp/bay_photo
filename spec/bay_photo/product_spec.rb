require "spec_helper"

RSpec.describe BayPhoto::Product do
  EXPECTED_ATTRIBUTES = %i[id name price print_size_x print_size_y square_inch]
  EXPECTED_ATTRIBUTES.each do |attr|
    it { should respond_to(attr) }
    it { should respond_to(:"#{attr}=") }
  end

  it "should define the correct resource" do
    expect(subject.resource).to eq(:products)
  end
end

