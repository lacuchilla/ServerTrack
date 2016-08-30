Rails.application.routes.draw do
  get '/servers' => 'servers#index'
  get '/servers/:id' => 'servers#show'
  get 'records/:server_id', to: 'records#show'
  #post 'records/:server_id', to: 'records#create'
  resources :records
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
