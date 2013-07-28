Photos::Application.routes.draw do
  resources :albums

  resources :photos do
    member do
      get 'tags'
      get 'people'
    end
  end
  
  resources :tags do
    member do
      get 'photos'
    end
  end

  resources :people do
    member do
      get 'photos'
    end
  end
  
  get "home/index"
  get "home/new"
  get "static_pages/about"
  
  match 'photo/people' => 'photos#photo_people'
  match 'person/photos' => 'people#person_photos'
  match 'people_by_photo_count' => 'people#photo_by_count'
  match 'people_by_name' => 'people#photo_by_name'
  match 'album/photos' => 'albums#album_photos'
  match 'album/thumbnails' => 'albums#album_thumbnails'
  match 'album/recent' => 'albums#album_recent'
  
  # The priority is based upon order of creation:
  # first created -> highest priority.

  # Sample of regular route:
  #   match 'products/:id' => 'catalog#view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   match 'products/:id/purchase' => 'catalog#purchase', :as => :purchase
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Sample resource route with options:
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

  # Sample resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Sample resource route with more complex sub-resources
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', :on => :collection
  #     end
  #   end

  # Sample resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # You can have the root of your site routed with "root"
  # just remember to delete public/index.html.
  root :to => 'home#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'
  

end
