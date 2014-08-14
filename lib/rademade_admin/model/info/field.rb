# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Info
      class Field

        UNSAVED_FIELDS = [:id, :_id, :created_at, :deleted_at, :position]

        attr_accessor :name, :setter, :getter, :type, :relation_name

        def key=(status)
          @is_key = status
        end

        def primary?
          @primary
        end

        def foreign_key?
          @foreign_key
        end

        def save?
          not UNSAVED_FIELDS.include? name
        end

        def has_relation?
          @relation_name
        end

        protected

        def initialize(opts = {})
          @name = opts[:name]
          @primary = opts[:primary]
          @foreign_key = opts[:foreign_key]
          @setter = opts[:setter]
          @getter = opts[:getter]
          @type = opts[:type]
          @relation_name = opts[:relation_name]
        end

      end
    end
  end
end