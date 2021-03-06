require "bundler/gem_tasks"
require "rspec/core/rake_task"
require "rake/clean"

CLEAN.include FileList["coverage/", "doc/", "tmp/*"]
CLOBBER.include FileList[".yardoc/"]

desc "Regenerate yard documentation"
task :doc do
  sh "bundle exec yard --no-stats --no-cache"
end

RSpec::Core::RakeTask.new(:spec)
task default: :spec

desc "Regenerate GitHub Pages branch"
task regen_gh_pages: :doc do
  current_branch = `git branch | grep "*" | awk '{ print $2 }'`.strip
  if current_branch.nil? or current_branch.empty?
    fail "Unable to determine current branch. Are you in a detached HEAD?"
  end

  doc_files = FileList["*.html", "BayPhoto/", "js/", "css/"]

  sh "git stash -u"
  sh "git checkout gh-pages"
  rm_rf FileList["Gemfile.lock"].include(doc_files)
  mv FileList["doc/*"], "."
  sh %(git add -A && git ci -m "Regenerated at #{Time.now}" && git push)
  sh "git checkout #{current_branch}"
  sh "git stash pop || true"
end

