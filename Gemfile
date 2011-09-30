source "http://rubygems.org"
# Note: "~> 1.2.1" means ">= 1.2.1" and "< 1.3.0"
gem "rake"
gem "rack",   "~> 1.1.0"
gem "rails",  "~> 2.3.11"

gem "pg" # postgresql adapter

gem "haml"
gem "sass"

gem "will_paginate"

# Exception notification for Rails 2.3:
gem 'exception_notification', "~> 2.3.0"

group :development do
  gem "capistrano"
  gem "capistrano-ext" # For multistage support.
end

group :test do
  # bundler requires these gems while running tests
  gem "rspec",        "~> 1.3.1"
  gem "rspec-rails",  "~> 1.3.1"

  gem "rcov"

  # For some reason we need version 1.2.3 for pre-Rails 3.
  gem "factory_girl", "~> 1.2.3"
end
