Rails.application.routes.draw do
  scope "(:locale)", locale: /en|ru/ do
    root "main#index"

    get  "main/index"
    get  "about", to: "main#about"
    get  "help",  to: "main#help"

    # work area
    get  "work",                to: "work#index",       as: :work
    get  "work/next_image",     to: "work#next_image",  as: :work_next_image
    get  "work/prev_image",     to: "work#prev_image",  as: :work_prev_image
    post "work/save_value",     to: "work#save_value",  as: :work_save_value

    # auth (has_secure_password)
    get    "signup",  to: "users#new",        as: :signup
    post   "signup",  to: "users#create"
    get    "signin",  to: "sessions#new",     as: :signin
    post   "signin",  to: "sessions#create"
    delete "signout", to: "sessions#destroy", as: :signout

    resources :users, only: [:show]
  end
end