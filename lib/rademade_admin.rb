# -*- encoding : utf-8 -*-
require 'kaminari'
require 'light_resizer'
require 'carrierwave'

require 'cancan'
require 'bower-rails'
require 'compass-rails'

# js assets
require 'turbolinks'

require 'i18n-js'

require 'slim'
require 'cells'
require 'simple_form'
require 'ckeditor'

require 'rademade_admin/sortable'
require 'rademade_admin/engine'

require 'mongoid_sortable_relation'

module RademadeAdmin

  def self.user_class
    RademadeAdmin::Configuration.user_class
  end

  def self.ability_class
    RademadeAdmin::Configuration.ability_class
  end

end
