# -*- encoding : utf-8 -*-
require 'search/conditions/abstract'

module RademadeAdmin
  module Search
    module Conditions
      class RelatedList < Abstract

        attr_reader :item

        protected

        def initialize(item, params, data_items)
          @item = item
          super(params, data_items)
        end

        def where
          where_conditions = RademadeAdmin::Search::Part::Where.new(:and)
          where_conditions.add(:id, related_item_ids)
          @params.slice(*@data_items.origin_fields).each do |field, value|
            where_conditions.add(field, value)
          end
          where_conditions
        end

        def order
          order_conditions = super
          field = @params[:sort] || default_order_field
          order_conditions.unshift(field, @params[:direction])
          order_conditions
        end

        def page
          @params[:page] || 1
        end

        def per_page
          @params[:paginate] || 20
        end

        private

        def default_order_field
          @data_items.has_field?(:position) ? :position : :id
        end

        def related_item_ids
          related_items = @item.send(params[:relation])
          related_items.map do |related_item|
            related_item.id.to_s
          end
        end

      end
    end
  end
end
