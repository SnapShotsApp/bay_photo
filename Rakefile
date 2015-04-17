require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/clean"

CLEAN.include FileList["coverage/", "tmp/*"]

RSpec::Core::RakeTask.new(:spec)
task default: :spec

