# -*- encoding : utf-8 -*-
module RademadeAdmin::MenuHelper

  def main_menu
    @model_infos = RademadeAdmin::Model::Graph.instance.root_models
    menu = collect_children
    unshift_root_url(menu)
  end

  def active?(menu_item)
    if menu_item[:is_current]
      true
    else
      menu_item[:sub].each do |sub_item|
        return true if active?(sub_item)
      end
      false
    end
  end

  private

  def unshift_root_url(menu)
    menu.unshift({
      :uri => root_url,
      :name => t('rademade_admin.home'),
      :ico => 'glyphicon glyphicon-home',
      :is_current => current_page?(root_url),
      :sub => []
    })
  end

  def collect_children(parent = nil)
    menu = []
    @model_infos.each do |model_info|
      if model_info.parent_menu_item == parent
        uri = admin_list_uri(model_info)
        menu << {
          :uri => uri,
          :model_info => model_info,
          :sub => collect_children(model_info.model.to_s),
          :is_current => current_menu?(uri, model_info)
        }
      end
    end
    menu
  end

  def current_menu?(uri, model_info)
    model_info == @model_info or (not uri.nil? and current_page?(uri))
  end

end
