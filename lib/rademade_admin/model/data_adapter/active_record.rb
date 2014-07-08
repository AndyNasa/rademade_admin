module RademadeAdmin
  module Model
    module DataAdapter
      class ActiveRecord
        include RademadeAdmin::Model::DataAdapter

        HAS_MANY_RELATIONS = [:has_many, :has_and_belongs_to_many].freeze
        HAS_ONE_RELATIONS = [:has_one, :belongs_to].freeze

        def relations
          @model.reflections
        end

        def reflect_on_association(name)
          @model.reflect_on_association(name)
        end

        def fields
          @model.column_types
        end

        def has_field?(field)
          fields.include? field
        end

        def foreign_key?(field)
          if field.is_a? ::ActiveRecord::AttributeMethods::TimeZoneConversion::Type # why another behaviour?
            field_name = field.instance_values['column'].name
          else
            field_name = field.name
          end
          field_name[-3, 3] == '_id'
        end

      end
    end
  end
end