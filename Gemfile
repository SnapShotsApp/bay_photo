source "https://rubygems.org"

# Specify your gem"s dependencies in bay_photo.gemspec
gemspec

group :development, :test do
  gem "rake",     "~> 10.0"
  gem "rspec",    "~> 3.2.0"
end

group :test do
  gem "simplecov"
end

group :docs do
  gem "yard"
  gem "redcarpet"
end

group :console do
  gem "pry", require: false
  gem "pry-doc", require: false
  gem "pry-stack_explorer", require: false
  gem "awesome_print", require: false
  gem "pry-byebug", require: false
  gem "coolline", require: false
  gem "coderay", require: false
end

group :guard do
  gem "guard", require: false
  gem "guard-rspec", require: false
  gem "guard-bundler", require: false
  gem "guard-bundler-audit", require: false
  gem "guard-rake", require: false
end

