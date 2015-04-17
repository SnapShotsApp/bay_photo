require "spec_helper"

RSpec.describe BayPhoto::Configuration do
  it { should respond_to(:access_token) }
  it { should respond_to(:access_token=) }
end

