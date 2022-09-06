Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"

  defaults format: :json do
    get '/health', to: ->(_env) { [204, {}, ['']] }

    resources :users, only: %i[index create]
    resource :users, only: :destroy
  end
end
