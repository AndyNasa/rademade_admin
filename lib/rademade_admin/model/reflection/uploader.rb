# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Model
    class Reflection
      module Uploader

        # todo return object classs
        def uploaders
          @model.respond_to?(:uploaders) ? @model.uploaders : []
        end

        def uploader_fields
          @model.respond_to?(:uploaders) ? @model.uploaders.keys : []
        end

      end
    end
  end
end
