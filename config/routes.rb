QuestTillDone::Application.routes.draw do
  get "welcome/index"
  devise_for :users
  resources :encounters do
    collection do
      get 'getTree', 'getState'
      post 'setState'
    end
  end
  resources :records
  resources :timers do
    collection do
      get 'get_current_time', 'get_setting_time', 'reset_timer'
      post 'start_timer', 'stop_timer'
    end
  end
  resources :users
  resources :quests do
    collection do
      get 'getTree'
      post 'set_active'
    end
  end
  resources :campaigns do
    collection do
      get 'getTree'
    end
  end

  resources :actions do
    collection do
      get 'getTree'
    end
  end

  get '/project', to: redirect('/')

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  root 'welcome#index'

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


  get '/timeline', to: redirect('/records')


  #
  # Profiles
  #
  resource :profile, only: [:show, :update] do
    member do
      get :history
      get :design

      put :reset_private_token
      put :update_username
    end

    scope module: :profiles do
      resource :account, only: [:show, :update]
      resource :notifications, only: [:show, :update]
      resource :password, only: [:new, :create, :edit, :update] do
        member do
          put :reset
        end
      end
      resources :keys
      resources :groups, only: [:index] do
        member do
          delete :leave
        end
      end
      resource :avatar, only: [:destroy]
    end
  end

  match "/u/:username" => "users#show", as: :user_profile, constraints: { username: /.*/ }, via: :get

end
