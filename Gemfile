source 'https://rubygems.org'

gemspec
gem 'devise'

# Assets
gem 'sass'
gem 'sass-rails'
gem 'compass'
gem 'compass-rails'
gem 'bower-rails'

# File upload
gem 'light_resizer'
gem 'carrierwave'
gem 'carrierwave-mongoid', :require => 'carrierwave/mongoid'
gem 'rmagick'

# Utility gems used in both development & test environments
gem 'rake', require: false

group :development, :test do
  gem 'pry'
end

group :test do
  gem 'coveralls', :require => false
  gem 'mongoid'
  gem 'mongoid-paranoia'
  gem 'mongoid_rails_migrations'
  gem 'mongoid-grid_fs'
  gem 'mongoid-tree'
  gem 'rspec', '>= 3'
  gem 'spork-rails'
  gem 'rspec-rails', '3.0.0'
  gem 'capybara'
  gem 'database_cleaner'
  gem 'capybara-webkit'
  gem 'factory_girl_rails', :require => false
  gem 'simplecov'
end
