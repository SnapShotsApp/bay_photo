require "bay_photo/base_model"
require "bay_photo/enum"

# Services API wrapper class
# @api Model
class BayPhoto::Service < BayPhoto::BaseModel
  # @!attribute id
  # @return [Integer] the type-coerced `id` attribute
  attribute :id, Integer
  # @!attribute name
  # @return [String] the type-coerced `name` attribute
  attribute :name, String
  # @!attribute service_type
  # @return [BayPhoto::Enum::EnumInstance] the type-coerced `service_type` attribute
  attribute :service_type, BayPhoto::Enum.define(:print, :image, :order, start_at: 1)

  resource :services
end

