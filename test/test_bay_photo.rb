require "minitest_helper"

# Primary module test
class TestBayPhoto < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::BayPhoto::VERSION
  end

  def test_it_does_something_useful
    assert true
  end
end

