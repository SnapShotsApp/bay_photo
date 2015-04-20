require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "bay_photo"

# Add spec/support to load path for easier requiring in spec files
$LOAD_PATH.unshift File.expand_path("../support", __FILE__)

RSpec.configure do |config|
  # rspec-expectations
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  # rspec-mocks
  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.filter_run :focus
  config.run_all_when_everything_filtered = true
  config.disable_monkey_patching!
  config.warnings = true
  config.profile_examples = 5
  config.order = :random
  Kernel.srand config.seed
end

