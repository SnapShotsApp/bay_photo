require "spec_helper"
require "net/http"

# Blank class with mixin to test
class MixinTest
  include BayPhoto::Mixins::HTTP
end

RSpec.describe BayPhoto::Mixins::HTTP do
  let(:subject) { MixinTest.new }

  context "SET_REQUEST_AUTH_TOKEN" do
    let(:subject) { described_class::SET_REQUEST_AUTH_TOKEN }

    it { should be_a(Proc) }

    it "accepts one argument" do
      expect(subject.arity).to eq(1)
    end

    it "sets the request auth token on the yield variable" do
      expect(BayPhoto::Configuration).to receive(:access_token).and_return("qwerty123")
      obj = double("Net::HTTPRequest")
      expect(obj).to receive(:[]=).with("Authorization", 'Token token="qwerty123"')

      subject.call(obj)
    end
  end

  context "API_ENDPOINTS" do
    let(:subject) { described_class::API_ENDPOINTS }

    it { should be_a(Hash) }
    it { should be_frozen }
    it { should have_key(:v1) }

    it "contains frozen URI objects" do
      subject.values.each do |uri|
        expect(uri).to be_a(URI)
        expect(uri).to be_frozen
      end
    end
  end

  context "#get" do
  end

  context "#post" do
  end

  context "#handle_response" do
    it "returns the parsed body as a hash on success" do
      resp = instance_double(Net::HTTPSuccess, body: '{ "foo": "bar" }')
      expect(Net::HTTPSuccess).to receive(:===).with(resp).and_return(true)
      expect(MultiJson).to receive(:load).with(resp.body, symbolize_keys: true).and_call_original

      out = subject.handle_response(resp)
      expect(out).to be_a(Hash)
      expect(out[:foo]).to eq("bar")
    end

    it "raises an exception on redirect" do
      resp = instance_double(Net::HTTPRedirection)
      expect(resp).to receive(:[]).with("location").and_return("example.com")
      expect(Net::HTTPRedirection).to receive(:===).with(resp).and_return(true)

      expect { subject.handle_response(resp) }.to raise_error do |err|
        expect(err.message).to eq("Unexpected redirect! Site tried to redirect to example.com")
        expect(err.response).to be(resp)
      end
    end

    it "raises an exception on bad statuses" do
      resp = instance_double(Net::HTTPNotFound, value: 404)

      expect { subject.handle_response(resp) }.to raise_error do |err|
        expect(err.message).to eq("Bad response from server: 404")
        expect(err.response).to be(resp)
      end
    end
  end

  context "#uri_path_for" do
  end

  context "#http_handle" do
  end
end

