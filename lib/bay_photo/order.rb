require "bay_photo/base_model"
require "bay_photo/customer"
require "bay_photo/order_products"

# Order API wrapper class
class BayPhoto::Order < BayPhoto::BaseModel
  # @macro [attach] attribute
  #   @!attribute
  #   @return [$2] the `$1` attribute
  attribute :order_name, String
  attribute :order_date, DateTime
  attribute :shipping_billing_code, String
  attribute :customer, BayPhoto::Customer
  attribute :products, BayPhoto::OrderProducts

  resource :orders
end

