module RademadeAdmin::CrudController::Templates

  def native_template_folder
    # 7 = "Admin::".length
    # 11 = "Controller".length
    # e.g. RademadeAdmin::QuestionAnswer::UsersController to "question_answer/users"
    self.class.to_s[7..-11].underscore
  end

  def template_folder
    #todo save in static variable
    template_exists?('_form', "admin/#{native_template_folder}") ? native_template_folder : 'abstract'
  end

  def form_template_path(real = false)
    "admin/#{template_folder}/" + (real ? '_' : '') + 'form'
  end

end