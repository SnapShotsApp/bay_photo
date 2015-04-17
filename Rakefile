require "bundler/gem_tasks"
require "rake/testtask"
require "rake/clean"

CLEAN.include FileList["coverage/", "tmp/*"]

Rake::TestTask.new do |t|
  t.libs << "spec"
  t.pattern = "spec/**/*_spec.rb"
  t.verbose = false
end
task default: :test

