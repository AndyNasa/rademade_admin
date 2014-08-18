# -*- encoding : utf-8 -*-
class RademadeAdmin::UsersController < RademadeAdmin::ModelController

  options do
    list :email, :first_name, :last_name
    form do
      email :hint => 'Электронная почта'
      avatar
      first_name
      last_name
      posts
      admin :boolean
    end
  end

end
