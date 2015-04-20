require "spec_helper"
require "ostruct"

RSpec.describe BayPhoto::Exceptions do
  it { should be_a(Module) }
end

RSpec.describe BayPhoto::Exceptions::BadJSON do
  it { should be_a(StandardError) }
end

RSpec.describe BayPhoto::Exceptions::BadRequestURIExtension do
  it { should be_a(StandardError) }
end

RSpec.shared_examples "response error" do
  let(:subject) { described_class.new(OpenStruct.new) }
  it { should be_a(StandardError) }
  it { should respond_to(:response) }
  it { should be_a(BayPhoto::Exceptions::ResponseError) }

  it "#response should respond with whatever was set in the initializer" do
    expect(subject.response).to be_a(OpenStruct)
  end
end

RSpec.describe BayPhoto::Exceptions::ResponseError do
  it_behaves_like "response error"
end

RSpec.describe BayPhoto::Exceptions::UnexpectedRedirect do
  it_behaves_like "response error"
end

RSpec.describe BayPhoto::Exceptions::BadResponse do
  it_behaves_like "response error"
end

