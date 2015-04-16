source "https://rubygems.org"

# Specify your gem's dependencies in bay_photo.gemspec
gemspec

group :development, :test do
  gem "rake",     "~> 10.0"
  gem "rspec",    "~> 3.2.0"
end

group :development do
  gem "guard", require: false
  gem "guard-rspec", require: false
  gem "guard-bundler", require: false
  gem "guard-bundler-audit", require: false
end

group :test do
  gem "simplecov"
end

