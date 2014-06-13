RademadeAdmin::Engine.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  devise_for :users, class_name: RademadeAdmin.user_class, module: :devise

  root 'dashboard#index'

  match 'file-upload' => 'file#upload', :via => [:post, :patch]

  get 'login' => 'dashboard#login', :as => 'login'

  resources :sessions do
    delete 'logout', :on => :collection
  end

  admin_resources :admin_users
end
