require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/clean"

CLEAN.include FileList["coverage/", "doc/", "tmp/*"]
CLOBBER.include FileList[".yardoc/"]

begin
  require "yard"
  YARD::Rake::YardocTask.new do |t|
    t.files         = ["lib/**/*.rb"]
    t.options       = ["--protected", "--markup", "markdown"]
    t.stats_options = ["--list-undoc"]
  end
  task doc: :yard
rescue LoadError
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec

