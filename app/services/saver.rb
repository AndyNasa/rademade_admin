# -*- encoding : utf-8 -*-
module RademadeAdmin
  class Saver

    attr_reader :item

    # Initialization of model saver class
    #
    # @param model_info [RademadeAdmin::Model::Info]
    # @param params [Hash]
    #
    def initialize(model_info, params)
      @model_info, @params = model_info, params
    end

    def create_model
      @item = @model_info.model.new(filter_data_params)
    end

    def update_model
      @item = @model_info.model.find(@params[:id])
      item.update filter_data_params
    end

    def save_model
      item.save filter_data_params
    end

    def save_aggregated_data
      save_model_relations
      save_model_uploads
      item.save!
    end

    def errors
      item.errors
    end

    private

    def save_model_relations
      data = @params[:data]
      @model_info.data_items.related_fields.each do |_, data_item|
        if data.has_key? data_item.getter
          item.send(data_item.setter, find_entities(data_item, data[data_item.getter]))
        end
      end
    end

    def save_model_uploads
      data = @params[:data]
      @model_info.data_items.uploader_fields.each do |_, data_item|
        name = data_item.name
        if data.has_key?(name) and not data[name].blank?
          image_path = "#{CarrierWave.root}#{data[name]}"
          begin
            item.send(data_item.setter, File.open(image_path))
          rescue
            # rm_todo clear image
          end
        end
      end
    end

    def find_entities(data_item, ids)
      if ids.kind_of? Array
        ids.reject! { |id| id.empty? }
        entities = related_entities(data_item, ids)
        sort_related_entities(data_item, entities)
      else
        ids.empty? ? nil : data_item.relation.related_entities(ids)
      end
    end

    def sort_related_entities(data_item, new_entities)
      if data_item.sortable_relation?
        clear_relations item.send(data_item.getter)
        new_entities.each_with_index do |entity, index|
          entity.send(data_item.sortable_setter, index + 1)
          entity.save
        end if data_item.relation.many?
        new_entities.each &:reload
      end
      # todo for AR
      new_entities
    end

    def filter_data_params
      @params.require(:data).permit(@model_info.data_items.save_form_fields)
    end

    def related_entities(data_item, ids)
      ids.map { |id| data_item.relation.related_entities(id) }
    end

    def clear_relations(related_items)
      related_items.nullify unless related_items.empty?
    end

  end
end
