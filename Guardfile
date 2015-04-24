# rubocop:disable Style/FileName
# vim: ft=ruby:

clearing :on

if ENV["TMUX"]
  # Only active this if we're in a tmux session.
  # Guard defaults to terminal title if no notification is set manually.
  notification :tmux,
               display_message: true,
               timeout: 5
end

guard :bundler_audit, run_on_start: true do
  watch("Gemfile.lock")
end

guard :bundler do
  require "guard/bundler"
  require "guard/bundler/verify"
  helper = Guard::Bundler::Verify.new

  files = ["Gemfile"]
  files += Dir["*.gemspec"] if files.any? { |f| helper.uses_gemspec?(f) }

  files.each { |file| watch(helper.real_path(file)) }
end

guard :rspec, cmd: "bin/rspec" do
  require "guard/rspec/dsl"
  dsl = Guard::RSpec::Dsl.new(self)

  # RSpec files
  rspec = dsl.rspec
  watch(rspec.spec_helper) { rspec.spec_dir }
  watch(rspec.spec_support) { rspec.spec_dir }
  watch(rspec.spec_files)

  # Ruby files
  ruby = dsl.ruby
  watch(ruby.lib_files) { |m| rspec.spec.call(m[1].sub(%r{\Alib/}, "")) }
end

guard :rake, task: :doc do
  watch(%r{^lib/.*?\.rb$})
  watch("README.md")
  watch("LICENSE.txt")
end

