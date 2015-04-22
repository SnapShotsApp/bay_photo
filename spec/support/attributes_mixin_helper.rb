# Class with mixin to test Attributes.
class AttributesMixinHelper
  include BayPhoto::Mixins::Attributes

  def self.clear_attributes!
    instance_exec do
      @__attributes ||= {}
      return if @__attributes.empty?

      @__attributes.keys.each do |sym|
        remove_method sym
        remove_method :"#{sym.to_s}="
      end

      @__attributes = {}
    end
  end
end

