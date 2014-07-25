# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Configuration
      class Fields

        attr_reader :fields

        def self.init_from_block(&block)
          model_fields = self.new
          model_fields.instance_eval(&block)
          model_fields
        end

        def self.init_from_options(field_options)
          model_fields = self.new(field_options)
          model_fields
        end

        def initialize(fields = [])
          @fields = fields
        end

        def find(name)
          name = name.to_sym
          field = @fields.select {|field| field.name == name}
          return nil if field.nil?
          yield( field ) if block_given?
          field
        end

        def method_missing(name, *arguments)
          @fields << RademadeAdmin::Model::Configuration::Field.new(name.to_sym, arguments.first)
        end

      end
    end
  end
end
