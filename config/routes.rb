Rails.application.routes.draw do

  resources :discovery_sessions, only: [:index, :show]

  resources :discoveries, only: [:index, :show] do
    member do
      post "search"
    end
    member do
      post "exportfull"
    end
    resources :attribute_types, only: [:index, :show] do
    end
  end

  resources :discovery_attributes, only: [:index, :show]

  resources :attribute_types, only: [:index, :show]

  resources :discovery_tools, only: [:index, :show]

  resources :documents, only: [:index, :show]

  resources :document_types, only: [:index, :show]

  resources :contracts, only: [:index, :show]

  resources :technologies, only: [:index, :show]

  resources :techno_instances, only: [:index, :show]

  resources :realisations, only: [:index, :show]

  resources :people, only: [:index, :show]

  resources :mainteners, only: [:index, :show]

  resources :lifecycles, only: [:index, :show]

  resources :entities, only: [:index, :show]

  resources :app_roles, only: [:index, :show]

  resources :hosts, only: [:index, :show]

  resources :deployments, only: [:index, :show]

  resources :applications, only: [:index, :show]

  resources :app_modules, only: [:index, :show]


  get 'main/search'
  get 'main/index'

  mount RailsAdmin::Engine => '/appsmgt', as: 'rails_admin'
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'main#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
