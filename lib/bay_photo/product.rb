require "bay_photo/base_model"

# Products API wrapper class
# @api Model
class BayPhoto::Product < BayPhoto::BaseModel
  # @macro [attach] attribute
  #   @!attribute $1
  #   @return [$2] the type-coerced `$1` attribute
  attribute :id, Integer
  attribute :name, String
  attribute :price, Float
  attribute :print_size_x, Float
  attribute :print_size_y, Float
  attribute :square_inch, Float

  resource :products
end

