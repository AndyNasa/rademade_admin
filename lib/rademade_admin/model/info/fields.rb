# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Info
      class Fields

        attr_reader :data_adapter, :model_configuration

        # Initialize
        #
        # @param data_adapter [RademadeAdmin::Model::Adapter::Data]
        # @param model_configuration [RademadeAdmin::Model::Configuration]
        # @param relations [RademadeAdmin::Model::Info::Relations]
        # @param uploaders [RademadeAdmin::Model::Info::Uploaders]
        #
        def initialize(data_adapter, model_configuration, relations, uploaders)
          @data_adapter = data_adapter
          @model_configuration = model_configuration
          @relations = relations
          @uploaders = uploaders
        end

        def data_items
          @data_items ||= init_data_items
        end

        private

        def init_data_items
          data_items = RademadeAdmin::Model::Info::DataItems.new
          used_relations = []

          @data_adapter.fields.each do |_, field|
            relation = @data_adapter.relation_by_key(field.name)
            used_relations << field.name if relation
            data_items.add_data_item(init_data_item(field, relation))
          end

          @data_adapter.relations.each do |_, relation|
            unless used_relations.include? relation.foreign_key
              data_items.add_data_item(init_data_item(nil, relation))
            end
          end

          @model_configuration.all_field_names.each do |field_name|
            data_item = data_items.data_item(field_name)
            unless data_item
              data_item = RademadeAdmin::Model::Info::DataItem.new(field_name)
              add_configuration_data(data_item, field_name)
              data_items.add_data_item(data_item)
            end
          end

          data_items
        end

        def init_data_item(field, relation)
          name = field.nil? ? relation.name : field.name
          data_item = RademadeAdmin::Model::Info::DataItem.new(name, field, relation, @uploaders.uploader(name))
          add_configuration_data(data_item, name)
          data_item
        end

        def add_configuration_data(data_item, name)
          @model_configuration.field_labels.find(name) do |label_data|
            data_item.label = label_data.label
          end

          @model_configuration.form_fields.find_with_index(name) do |form_field_data, index|
            data_item.form_params = form_field_data.params
            data_item.in_form = true
            data_item.form_position = index
          end

          @model_configuration.list_fields.find_with_index(name) do |_, index|
            data_item.in_list = true
            data_item.list_position = index
          end
        end

      end
    end
  end
end