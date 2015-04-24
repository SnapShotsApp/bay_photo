# Array of products in an {Order} model for coercion.
# @api private
class BayPhoto::OrderProducts < Array
  # Actual product contained as entries in the {OrderProducts} array.
  class OrderProduct
    # Service contained in {OrderProduct} for coercion.
    class OrderService
      include BayPhoto::Mixins::Attributes

      # @macro [attach] attribute
      #   @!attribute
      #   @return [$2] the `$1` attribute
      attribute :service_id, Integer
    end

    include BayPhoto::Mixins::Attributes

    # @macro [attach] attribute
    #   @!attribute
    #   @return [$2] the `$1` attribute
    attribute :product_id, Integer
    attribute :qty, Integer
    attribute :image_file_name, String
    attribute :image_source_path, String
    attribute :crop_height, String
    attribute :crop_width, String
    attribute :crop_x, String
    attribute :crop_y, String
    attribute :degrees_rotated, Integer
    attribute :print_services, OrderService
  end

  # Create a new instance with coercion.
  #
  # @param input [Hash|Array<Hash>] the input from the coercion in {BayPhoto::Order}
  def initialize(input)
    Array(input).each { |row| push row }
  end

  # Append an element to this array. Performs coercion if needed.
  #
  # @param input [OrderProduct|Hash] the input to coerce.
  #   If the input is already an {OrderProduct}, just append directly.
  # @return [self]
  def push(input)
    if input.is_a? OrderProduct
      super.push input
    else
      super.push OrderProduct.new(input)
    end
  end
  alias_method :<<, :push
end

