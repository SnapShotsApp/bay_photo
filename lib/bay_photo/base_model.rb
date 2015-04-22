# Base model class. All other model classes should extend.
# @api Model
# @abstract
class BayPhoto::BaseModel
  include BayPhoto::Mixins::HTTP
  include BayPhoto::Mixins::Attributes
  # @!parse extend BayPhoto::Mixins::Attributes::ClassMethods

  # Create a new instance of a model class.
  #
  # @param attrs [Hash] has of attributes to set on the new model.
  def initialize(attrs = {})
    update_attributes! attrs
  end

  # Fetch the array of objects from the API.
  #
  # @return [Array<BaseModel>] the array of instantiated model objects
  def self.all
    new.get(@__resource).map { |row| new(row) }
  end

  # Sets the default resource path to pass to {Mixins::HTTP#get} and {Mixins::HTTP#post}.
  #
  # @param res [Symbol|String] the resource to fetch for this model
  # @return [void]
  def self.resource(res)
    @__resource = res
  end
end

