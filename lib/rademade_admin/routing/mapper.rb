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
              get :link_autocomplete
              get :related_index if parent_resource_actions.include? :index
              patch :re_sort
            end

            new do
              get :form
            end if parent_resource_actions.include? :new

            member do
              get :form if parent_resource_actions.include? :edit
              post :unlink_relation if parent_resource_actions.include? :update
              put :link_relation if parent_resource_actions.include? :update
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
