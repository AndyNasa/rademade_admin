# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Configuration

      attr_reader :parent_menu_item, :list_fields, :form_fields

      def initialize(controller_name)
        @controller_name = controller_name
      end

      def model_name
        @model_name ||= @controller_name.classify
      end

      def item_name
        @item_name ||= model_name.underscore.gsub('/', '_').humanize
      end

      def model_class
        @model_class ||= RademadeAdmin::LoaderService.const_get(model_name)
      end

      def field_labels
        @field_labels ||= Labels.new
      end

      private

      def model(model_name)
        @model_name = model_name
      end

      def name(item_name)
        @item_name = item_name
      end

      def parent_menu(parent_menu_item)
        @parent_menu_item = parent_menu_item
      end

      def labels(&block)
        field_labels.init_from_block(&block)
      end

      def list(*field_options, &block)
        @list_fields = fields(*field_options, &block)
      end

      def form(*field_options, &block)
        @form_fields = fields(*field_options, &block)
      end

      def fields(*field_options, &block)
        model_fields = block_given? ? Fields.init_from_block(&block) : Fields.init_from_options(field_options)
        model_fields.fields
      end

    end
  end
end
