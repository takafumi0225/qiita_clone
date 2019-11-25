Rails.application.routes.draw do
  namespace :api, { format: 'json' } do
    namespace :v1 do # バージョン1を表している
      resources :articles
      mount_devise_token_auth_for "User", at: "auth"
    end
  end
end
