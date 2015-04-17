# Configuration wrapper module
module BayPhoto::Configuration
  class << self
    # @return [String] The access token provided by Bay for your API user
    attr_accessor :access_token
  end
end

