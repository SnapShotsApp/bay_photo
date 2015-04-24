require "multi_json"

# Mixin for the attribute DSL method
# @api Model
module BayPhoto::Mixins::Attributes
  # Class methods extended via the {.included} hook
  module ClassMethods
    # Define a type-coerced attribute on the model, fetched from the API.
    #
    # @!scope class
    # @param attr_name [Symbol] the name of the attribute
    # @param type [Class] the class to coerce the attribute into.
    #   If `nil`, skips coercion and sets the attribute to whatever is
    #   returned by the API.
    # @return [void]
    # @macro [attach] attribute
    #   @!attribute $1
    #   @return [$2] the `$1` attribute from the API
    def attribute(attr_name, type = nil)
      instance_exec do
        @__attributes ||= {}
        @__attributes[attr_name] = type

        attr_reader attr_name

        define_method :"#{attr_name}=" do |val|
          set_val = val

          unless type.nil?
            begin
              if type == Symbol
                # Symbol is special since it can't be instantiated and has no Kernel
                # helper method for it, so call #to_sym on the input directly.
                set_val = set_val.to_sym
              elsif Kernel.respond_to? type.to_s.to_sym
                # If the type has a built-in coercion function in {Kernel}, use that
                set_val = Kernel.__send__(type.to_s.to_sym, set_val)
              else
                # Otherwise, try to instantiate it
                set_val = type.new(set_val)
              end
            rescue StandardError => e
              raise BayPhoto::Exceptions::CoercionFailure, "Unable to coerce #{attr_name} to #{type}: #{e.message}"
            end
          end

          instance_variable_set(:"@#{attr_name}", set_val)
        end
      end
    end
  end

  # Sets the attributes on the model from a hash. Ignores keys that have
  # not been declared as attributes on the model via the DSL.
  #
  # @param attrs [Hash] the hash of attributes to update
  # @return [void]
  # @raise [BayPhoto::Exceptions::CoercionFailure] if an attribute is unable to be coerced into a type
  def update_attributes!(attrs)
    defined_attributes.keys.each do |defined_attr|
      next unless attrs.key? defined_attr

      val = attrs[defined_attr]
      __send__ :"#{defined_attr}=", val
    end
  end

  # Get the attributes definition hash set on the class by the attribute macro.
  #
  # @api private
  # @return [Hash] the attribute hash
  def defined_attributes
    self.class.instance_exec { @__attributes ||= {} }
    self.class.instance_variable_get(:@__attributes)
  end

  # Returns the Hash representation of the attributes defined
  # on the class.
  #
  # @return [Hash] the attributes as a Hash
  def to_hash
    hash = {}
    defined_attributes.keys.each { |key| hash[key] = __send__(key) }
    hash
  end

  # Returns the stringified JSON representation of the attributes defined
  # on the class.
  #
  # @param options [Hash] options hash possibly passed from MultiJson doing
  #   a recursive dump. Passed through to the MultiJson call.
  # @return [String] the dumped JSON string
  def to_json(options = {})
    MultiJson.dump to_hash, options
  end

private

  def self.included(base)
    base.extend ClassMethods
  end
end

