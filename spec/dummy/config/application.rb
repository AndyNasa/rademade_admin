# -*- encoding : utf-8 -*-
require File.expand_path('../boot', __FILE__)

require 'rails/all'
require 'mongoid'
require 'carrierwave/mount'
require 'carrierwave/mongoid'
require 'light_resizer'

Bundler.require(*Rails.groups)
require 'rademade_admin'

module Dummy
  class Application < Rails::Application

    config.assets.paths << Rails.root.join("app", "assets", "fonts")

    config.autoload_paths += Dir["#{Rails.root}/lib/**/"]

    config.middleware.insert_before(Rack::Sendfile, LightResizer::Middleware, Rails.root)

    config.i18n.available_locales = [:en, :ru]

  end
end

