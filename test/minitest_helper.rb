$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "bay_photo"

require "minitest/pride" unless ENV["NO_COLOR"].to_i == 1
require "minitest/autorun"

