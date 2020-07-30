Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :transactions
      post '/country' => 'transactions#one_country'
      get "/revenues/all" => "transactions#all"
    end
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
