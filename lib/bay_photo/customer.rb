# Customer object for use in {Order} model
class BayPhoto::Customer
  include BayPhoto::Mixins::Attributes
  # @!parse extend BayPhoto::Mixins::Attributes::ClassMethods

  # @macro [attach] attribute
  #   @!attribute $1
  #   @return [$2] the `$1` attribute
  attribute :name, String
  attribute :email, String
  attribute :phone, String
  attribute :address1, String
  attribute :address2, String
  attribute :city, String
  attribute :state, String
  attribute :country, String
  attribute :zip, String
end

