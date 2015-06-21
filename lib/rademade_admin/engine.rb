# -*- encoding : utf-8 -*-
require 'rademade_admin/routing/mapper'
require 'simple_form'
require 'breadcrumbs'

module RademadeAdmin
  class Engine < ::Rails::Engine
    isolate_namespace RademadeAdmin

    # Assets components
    config.assets.paths << "#{config.root}/vendor/assets/javascript/bower_components"

    initializer 'ckeditor.assets_precompile', :group => :all do |app|
      app.config.assets.precompile += %w( rademade_admin.css rademade_admin.js ckeditor/* )
    end

    # Auto-loading
    $LOAD_PATH << "#{config.root}/app/services/"

    %W(
      #{config.root}/app/helpers/**/*.rb
      #{config.root}/app/services/**/*.rb
      #{config.root}/app/exceptions/**/*.rb
      #{config.root}/app/cells/**/*.rb
      #{config.root}/app/inputs/**/*.rb
      #{config.root}/lib/rademade_admin/**/*.rb
    ).each do |path|
      Dir[path].each { |f| require f  }
    end

    # Components validation
    RademadeAdmin::Bootstrap::Components.new.validate

  end
end

