require "uri"
require "net/http"
require "multi_json"

# HTTP mixin for ease of use
# @api HTTP
module BayPhoto::Mixins::HTTP
  # Convenience proc for setting the BayPhoto auth header
  # @yieldparam req [Net::HTTPRequest] The request object
  SET_REQUEST_AUTH_TOKEN = proc do |req|
    req["Authorization"] = %Q[Token token="#{BayPhoto::Configuration.access_token}"]
  end

  # Hash of API endpoint versions
  API_ENDPOINTS = {
    v1: URI("https://pricing.bayphoto.com/api/v1").freeze
  }.freeze

  # Perform an `HTTP GET` request against the resource in
  # the specified API version.
  #
  # @param resource [String|Symbol] The resource to fetch
  # @param version [Symbol] The API version to use
  # @return [Hash] The parsed JSON response
  # @raise (see #handle_response)
  def get(resource:, version: :v1)
    handle = http_handle(version: version)

    req = Net::HTTP::Get.new(uri_path_for(resource: resource, version: version))
    SET_REQUEST_AUTH_TOKEN.call(req)

    handle_response(handle.request(req))
  end

  # Perform an `HTTP POST` request against the resource in the
  # specified API version.
  #
  # @param (see #get)
  # @param data [Hash|String] a Hash (to be converted to JSON) or
  #   raw JSON string to pass as data to the endpoint
  # @return [Hash] The parsed JSON response
  # @raise (see #handle_response)
  # @raise [BayPhoto::Exceptions::BadJSON] if the `data` param is a
  #   string and does not pass JSON validation
  def post(resource:, data:, version: :v1)
    if data.is_a? String
      begin
        MultiJson.load data
      rescue MultiJson::ParseError => e
        raise BadJSON, "Invalid JSON string: #{e.message}"
      end
    else
      data = MultiJson.dump data
    end

    handle = http_handle(version: version)

    req = Net::HTTP::Post.new(uri_path_for(resource: resource, version: version))
    req["Content-Type"] = "application/json"
    SET_REQUEST_AUTH_TOKEN.call(req)
    req.body = data

    handle_response(handle.request(req))
  end

  # Dispatch function for response object from {#get} and {#post}.
  #
  # @api private
  # @param resp [Net::HTTPResponse] The response object from the public api
  # @raise [BayPhoto::Exceptions::UnexpectedRedirect] when any redirect is encountered
  # @raise [BayPhoto::Exceptions::BadResponse] on any non-success, non-redirect response
  # @return [Hash] The parsed JSON response
  def handle_response(resp)
    case resp
    when Net::HTTPSuccess then
      MultiJson.load resp.body, symbolize_keys: true
    when Net::HTTPRedirection then
      # None of the endpoints should redirect so fail if this ever happens.
      fail BayPhoto::Exceptions::UnexpectedRedirect.new(resp),
           "Unexpected redirect! Site tried to redirect to #{resp['location']}"
    else
      fail BayPhoto::Exceptions::BadResponse.new(resp), "Bad response from server: #{resp.value}"
    end
  end

  # Generate a URI path from a version and resource.
  #
  # @api private
  # @param resource [String|Symbol] Either a string or symbol representation of the resource
  # @param version [Symbol] The API version to use
  # @return [String] The uri path
  def uri_path_for(resource:, version: :v1)
    resource = resource.to_s
    resource << ".json" if resource !~ /\.json\Z/

    URI.join(API_ENDPOINTS[version], resource).request_uri
  end

  # Fetch the HTTP connection handle for a given API version.
  #
  # @api private
  # @param version [Symbol] The API version to use
  # @return [Net::HTTP] The HTTP connection handle
  def http_handle(version: :v1)
    @__handles ||= []

    if @__handles[version].nil?
      uri = API_ENDPOINTS[version]
      handle = Net::HTTP.new(uri.host, uri.port)
      handle.use_ssl = true
      @__handles[version] = handle
    end

    @__handles[version]
  end
end

