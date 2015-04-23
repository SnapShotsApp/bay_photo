# Simple implementation of the Enum pattern to be used as
# an attribute coercion in Models.
# @api private
module BayPhoto::Enum
  # Instance of an {Enum} definition.
  # @see Enum.define
  # @api private
  # @abstract
  class EnumInstance
    # @return [Integer|Symbol] the corresponding value of the {Enum} input
    # @see #initialize
    attr_reader :value

    # Create a new EnumInstance with {#value} set to the correspondance of
    # the input. If the input is a Symbol, the {#value} is set to the
    # Integer value of the Enum definition. If the input is an Integer,
    # it's the reverse.
    #
    # @param input [Symbol|Integer] the Symbol or Integer to convert
    # @raise [RuntimeError] if a type other than Symbol or Integer is supplied
    # @raise [RuntimeError] if the value is out of bounds from the Enum definition
    def initialize(input)
      @value = case input
               when Integer
                 sym = args[input - start_at]
                 fail "Enum out of bounds: #{input}" if sym.nil?
                 sym
               when Symbol
                 int = args.index(input)
                 fail "Enum out of bounds: #{input}" if int.nil?
                 int + start_at
               else
                 fail "Invalid Enum input: #{input}"
               end
    end

    # Fetch the value of the class-instance variable `@args`
    #
    # @!attribute [r] args
    # @return [Array<Symbol>] the `args` passed in from {Enum.define}
    def args
      self.class.instance_exec do
        @args ||= []
      end

      self.class.instance_variable_get(:@args)
    end

    # Fetch the value of the class-instance variable `@start_at`
    #
    # @!attribute [r] start_at
    # @return [Integer] the `start_at` passed in from {Enum.define}
    def start_at
      self.class.instance_exec do
        @start_at ||= 0
      end

      self.class.instance_variable_get(:@start_at)
    end
  end

  # Create a new anonymous {EnumInstance} class definition,
  # similar to how Struct.new works.
  #
  # @param args [*Symbol] the list of symbols to translate
  # @param start_at [Integer] the index the enum should start at
  # @raise [RuntimeError] if the args splat is blank
  # @raise [RuntimeError] if the args splat contains anything other than Symbols
  # @return [Class<EnumInstance>] the {EnumInstance} class
  #
  # @example Zero-indexed with 4 values
  #   enum = Enum.define(:foo, :bar, :baz, :qux)
  #   enum.new(:bar).value    # => 1
  #   enum.new(:pants).value  # => RuntimeError
  #   enum.new(2).value       # => :baz
  #
  # @example 2-indexed with 2 values
  #   enum = Enum.define(:foo, :bar, start_at: 2)
  #   enum.new(:foo).value    # => 2
  def self.define(*args, start_at: 0)
    fail "Must have at least one symbol in args list" if args.nil? or args.empty?
    fail "All args must be Symbols" unless args.all? { |arg| arg.is_a? Symbol }

    Class.new(EnumInstance) do
      @args = args
      @start_at = start_at
    end
  end
end

