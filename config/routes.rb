Rails.application.routes.draw do
  get 'login' => 'sessions#new'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post 'login' => 'sessions#create'
  get "logout" => "sessions#destroy", as: "logout"

  root "to_buy#index"
  get "list_api" => "to_buy#list_api"


  get "auth/invite" => "invite#new" , as: "user_create"
  post "auth/invite" => "invite#create_temp" , as: "user_create_post"


  get 'auth/token/(:uuid)' , :to => "invite#check_token" 
  post 'auth/token/(:uuid)' , :to => "invite#create_user" , as: "real_user_create"


  post "delete" => "to_buy#delete"
  post "change" => "to_buy#change_done"
  get "new" => "to_buy#new" , as: "to_buy_new"
  post "create" => "to_buy#create"
end

