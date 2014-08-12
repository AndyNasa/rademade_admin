# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Routing
    module Mapper

      def admin_resources(*resources, &block)

        admin_resources = resources.dup
        options = admin_resources.extract_options!.dup

        admin_resources.each do |resource|
          resource_scope(:resources, Resource.new(resource, options)) do
            yield if block_given?

            parent_resource_actions = @scope[:scope_level_resource].actions

            collection do
              get :autocomplete
              patch :sort
            end

            new do
              get :form if parent_resource_actions.include? :new
            end

            member do
              get :form if parent_resource_actions.include? :edit

              scope 'related/:relation' do
                get '/' => :related, :as => :related
                post '/' => :related_add, :as => :related_add
                delete ':related_id' => :related_destroy, :as => :related_destroy
              end

            end

            Model::Graph.instance.add_pair(@scope[:controller], self.shallow?)

          end
        end

        resources(*resources, &block)

        self
      end
    end
  end
end
