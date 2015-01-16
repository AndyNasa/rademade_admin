# -*- encoding : utf-8 -*-
module RademadeAdmin
  module Notifier

    def success_action
      render :json => {
        :message => I18n.t('rademade_admin.success_message')
      }
    end

    def success_insert(item)
      respond_to do |format|
        format.html { redirect_to admin_edit_uri(item) }
        format.json {
          if params.has_key?(:create_and_return)
            data = { :redirect_to => admin_list_uri(item.class) }
          else
            data = { :form_action => admin_update_uri(item) }
          end
          success_message(item, I18n.t('rademade_admin.success_insert_message'), data)
        }
      end
    end

    def success_update(item)
      respond_to do |format|
        format.html { redirect_to admin_edit_uri(item) }
        format.json {
          data = {}
          data[:redirect_to] = admin_list_uri(item.class) if params.has_key?(:create_and_return)
          success_message(item, I18n.t('rademade_admin.success_update_message'), data)
        }
      end
    end

    def success_delete(item)
      respond_to do |format|
        format.html { redirect_to admin_list_uri(item) }
        format.json {
          success_message(item, I18n.t('rademade_admin.success_delete_message'))
        }
      end
    end
    
    def success_status_change(item)
      respond_to do |format|
        format.html { redirect_to admin_list_uri(item) }
        format.json {
          success_message(item, t('rademade_admin.success_status_update_message'))
        }
      end
    end

    def success_unlink
      render :json => {
        :message => I18n.t('rademade_admin.success_unlink_message')
      }
    end

    def success_link
      render :json => {
        :message => I18n.t('rademade_admin.success_link_message')
      }
    end

    def success_message(item, message, additional_data = {})
      render :json => {
        :data => Autocomplete::BaseSerializer.new([item]).as_json.first,
        :message => message
      }.merge(additional_data)
    end

  end
end
