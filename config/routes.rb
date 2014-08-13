Rails.application.routes.draw do
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

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
  post "api/user/register" => "user#CreateUser"
  post "api/user/auth" => "user#AuthUser"
  post "api/user/wantlist/add" => "user#AddWantList"
  post "api/user/wantlist/list" => "user#GetWantList"
  post "api/user/wantlist/edit" => "user#EditWantList"
  delete "api/user/wantlist/edit" => "user#EditWantList"
  post "api/user/wantlist/item/add" => "user#AddItemToWantList"
  post "api/user/wantlist/item/edit" => "user#EditItem"
  delete "api/user/wantlist/item/edit" => "user#EditItem"
  post "api/user/wantlist/item/comment/add" => "user#AddComment"
  post "api/user/wantlist/item/comment/edit" => "user#EditComment"
end
