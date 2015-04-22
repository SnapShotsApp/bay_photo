require "bay_photo/version"
require "bay_photo/configuration"

# Primary namespace module
module BayPhoto
  autoload :Mixins,     "bay_photo/mixins"
  autoload :Exceptions, "bay_photo/exceptions"
  autoload :Product,    "bay_photo/product"

  # Set configuration attributes globally.
  #
  # @yieldparam config [BayPhoto::Configuration] The configuration class
  # @return [void]
  # @example Set the Access Token
  #   BayPhoto.configure do |config|
  #     config.access_token = "abc123"
  #   end
  def self.configure
    yield BayPhoto::Configuration
  end
end

