require "spec_helper"
require "uri"
require "net/http"
require "http_mixin_helper"

##
# NOTE: All URIs in this file *must* have trailing slashes or specs will fail!
##

RSpec.describe BayPhoto::Mixins::HTTP do
  let(:subject) { HTTPMixinHelper.new }

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
    before(:each) do
      @http = instance_double(Net::HTTP, request: :response)
      expect(subject).to receive(:http_handle).with(version: :v1).and_return(@http)
    end

    it "defaults to version: :v1" do
      allow(subject).to receive(:handle_response).with(:response).and_return(true)
      expect(subject.get(resource: :foo)).to be true
    end

    it "sets the headers on the request" do
      allow(subject).to receive(:handle_response).with(:response).and_return(true)

      request = Net::HTTP::Get.new "/foo"
      expect(Net::HTTP::Get).to receive(:new).and_return(request)
      subject.get(resource: :foo)
      expect(request.to_hash).to include("authorization")
    end

    it "requests the specified resource" do
      endpoints_mock = double("API_ENDPOINTS", :[] => URI("http://foo.com/bar/"))
      stub_const("#{described_class}::API_ENDPOINTS", endpoints_mock)

      request = Net::HTTP::Get.new "/foo"
      response = double("Response")

      expect(Net::HTTP::Get).to receive(:new).with("/bar/foo.json").and_return(request)
      expect(@http).to receive(:request).with(request).and_return(response)
      expect(subject).to receive(:handle_response).with(response).and_return(:handled)

      expect(subject.get(resource: :foo)).to eq(:handled)
    end
  end

  context "#post" do
    before(:each) do
      @http = instance_double(Net::HTTP, request: :response)
      allow(subject).to receive(:http_handle).with(version: :v1).and_return(@http)
      allow(subject).to receive(:handle_response).with(:response).and_return(:handled)

      endpoints_mock = double("API_ENDPOINTS", :[] => URI("http://foo.com/bar/"))
      stub_const("#{described_class}::API_ENDPOINTS", endpoints_mock)
    end

    it "validates JSON string data" do
      data = %({ foo": 12" })
      expect { subject.post(resource: :foo, data: data) }.to raise_error do |e|
        expect(e).to be_a(BayPhoto::Exceptions::BadJSON)
      end
    end

    it "converts hash data into a JSON string" do
      data = { foo: "bar" }
      expect(MultiJson).to receive(:dump).with(data).and_call_original
      subject.post(resource: :foo, data: data)
    end

    it "sets the correct headers and post body" do
      request = Net::HTTP::Post.new "/foo/bar.json"
      expect(Net::HTTP::Post).to receive(:new).with("/bar/resource.json").and_return(request)

      subject.post(resource: :resource, data: {})

      expect(request.body).to eq("{}")
      expect(request["content-type"]).to eq("application/json")
      expect(request.to_hash).to include("authorization")
    end
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
    before(:each) do
      @endpoints_mock = double("API_ENDPOINTS", :[] => URI("http://foo.com/bar/"))
      stub_const("#{described_class}::API_ENDPOINTS", @endpoints_mock)
    end

    it "defaults to version: :v1" do
      expect(@endpoints_mock).to receive(:[]).with(:v1)
      subject.uri_path_for resource: :foo
    end

    it "grabs the API URI verison specified" do
      expect(@endpoints_mock).to receive(:[]).with(:v3).and_return(URI("http://example.com/foo/bar/"))
      expect(subject.uri_path_for resource: :foo, version: :v3).to eq("/foo/bar/foo.json")
    end

    it "accepts a symbol as the resource" do
      res = :resource
      expect(subject.uri_path_for(resource: res)).to eq("/bar/resource.json")
    end

    it "accepts a string without the extension" do
      res = "resource"
      expect(res).to receive(:<<).with(".json").and_call_original
      expect(subject.uri_path_for(resource: res)).to eq("/bar/resource.json")
    end

    it "accepts a string with the extension" do
      res = "resource.json"
      expect(res).not_to receive(:<<)
      expect(subject.uri_path_for(resource: res)).to eq("/bar/resource.json")
    end

    it "fails if the resource has an extension other than .json" do
      res = "resource.xml"
      expect { subject.uri_path_for(resource: res) }.to raise_error do |e|
        expect(e.message).to eq("Tried to fetch a .xml URI, but only JSON is supported")
      end
    end
  end

  context "#http_handle" do
    before(:each) do
      @endpoint = instance_double(URI::HTTP, host: "foo.com", port: 80)
      @endpoints_mock = double("API_ENDPOINTS", :[] => @endpoint)
      stub_const("#{described_class}::API_ENDPOINTS", @endpoints_mock)

      subject.instance_variable_set(:@__handles, nil)
    end

    it "defaults to version: :v1" do
    end

    it "creates a new handle for a given version" do
      handle = instance_double(Net::HTTP)
      expect(Net::HTTP).to receive(:new).with("foo.com", 80).and_return(handle)
      expect(handle).to receive(:use_ssl=).with(true)

      expect(subject.http_handle(version: :v1)).to eq(handle)

      handles = subject.instance_variable_get(:@__handles)
      expect(handles).to be_a(Hash)
      expect(handles).to include(:v1)
      expect(handles[:v1]).to eq(handle)
    end

    it "returns the handle for a given version if it's in the cache" do
      handle = double("handle", nil?: false)
      handles = double("handles")
      subject.instance_variable_set(:@__handles, handles)

      expect(handles).to receive(:[]).with(:v4).at_least(:once).and_return(handle)
      expect(subject.http_handle(version: :v4)).to eq(handle)
    end
  end
end

