require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/clean"
require "yard"

CLEAN.include FileList["coverage/", "doc/", "tmp/*"]
CLOBBER.include FileList[".yardoc/"]

YARD::Rake::YardocTask.new do |t|
  t.files         = ["lib/**/*.rb"]
  t.options       = ["--protected", "--markup", "markdown"]
  t.stats_options = ["--list-undoc"]
end
task doc: :yard

RSpec::Core::RakeTask.new(:spec)
task default: :spec

