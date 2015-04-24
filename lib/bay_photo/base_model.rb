# Base model class. All other model classes should extend.
# @api Model
# @abstract
class BayPhoto::BaseModel
  include BayPhoto::Mixins::HTTP
  include BayPhoto::Mixins::Attributes
  # @!parse extend BayPhoto::Mixins::Attributes::ClassMethods

  # Create a new instance of a model class.
  #
  # @param attrs [Hash] hash of attributes to set on the new model.
  def initialize(attrs = {})
    update_attributes! attrs
  end

  # Fetch the array of subclassed model objects from the API.
  #
  # @return [Array<BaseModel>] the array of instantiated model objects
  def self.all
    Array(new.get(resource: @__resource)).map { |row| new(row) }
  end

  # Sets the default resource path to pass to {Mixins::HTTP#get} and {Mixins::HTTP#post}.
  #
  # @param res [Symbol|String] the resource to fetch for this model
  # @return [void]
  def self.resource(res)
    @__resource = res
  end

  # Create a new instance of the model class and {#save} it.
  #
  # @param (see #initialize)
  # @return [BaseModel] the new, persisted model
  def self.create(attrs)
    obj = new(attrs)
    obj.save
    obj
  end

  # Gets the class-level resource at the instance level
  #
  # @return [Symbol|String] the resource path
  def resource
    self.class.instance_exec { @__resource ||= nil }
    self.class.instance_variable_get(:@__resource)
  end

  # Post the model attributes to the API
  #
  # @return [Net::HTTPResponse] the HTTP response
  def save
    post(resource: resource, data: self)
  end
end

