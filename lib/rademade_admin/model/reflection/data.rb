module RademadeAdmin
  module Model
    class Reflection
      module Data

        ORM_TYPE_ACTIVERECORD = 'ActiveRecord'
        ORM_TYPE_MONGOID = 'Mongoid'

        def association_fields
          relations.keys.map &:to_sym
        end

        def data_adapter
          @data_adapter ||= init_data_adapter
        end

        def orm_type
          @orm_type # todo check if called earlier than data_adapter
        end

        def method_missing(name, *arguments)
          if data_adapter.respond_to? name
            data_adapter.send(name, *arguments)
          end
        end

        private

        def init_data_adapter
          adapter_map = {
            'ActiveRecord::Base' => ORM_TYPE_ACTIVERECORD,
            'Mongoid::Document' => ORM_TYPE_MONGOID
          }
          adapter_map.each do |ar_class, orm_type|
            if @model.ancestors.include? ar_class.constantize
              @orm_type = orm_type
              return "RademadeAdmin::Model::DataAdapter::#{orm_type}".constantize.new(@model)
            end
          end
          nil
        end

      end
    end
  end
end