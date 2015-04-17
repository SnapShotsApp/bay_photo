# Exceptions container namespace
module BayPhoto::Exceptions
  # Base response error class, containing the response object
  class ResponseError < StandardError
    # @return [Net::HTTPResponse] Object responsible for the exception
    attr_reader :response

    # @param response [Net::HTTPResponse] Object to set in the {#response} getter
    def initialize(response)
      @response = response.freeze
    end
  end

  # Failure state for a redirect on any endpoint
  class UnexpectedRedirect < ResponseError; end

  # Failure state for non-redirect, non-success response
  class BadResponse < ResponseError; end

  # Failure state for bad JSON string passed to {BayPhoto::Mixins::HTTP#post}
  class BadJSON < StandardError; end
end

