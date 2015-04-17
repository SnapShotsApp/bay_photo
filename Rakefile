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

desc "Regenerate GitHub Pages branch"
task regen_gh_pages: [:clobber, :doc] do
  doc_files = FileList["*.html", "BayPhoto/", "js/", "css/"]

  sh "git stash -u"
  sh "git checkout gh-pages"
  rm_rf FileList["Gemfile.lock"].include(doc_files)
  mv FileList["doc/*"], "."
  sh %(git add -A && git ci -m "Regenerated at #{Time.now}" && git push)
  sh "git checkout master"
  sh "git stash pop"
end

