# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Configuration
      class FormField

        attr_accessor :name, :options

        def initialize(name, options= {})
          @name, @options = name, options
        end

      end
    end
  end
end