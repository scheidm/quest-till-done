require 'sidekiq/web'

QuestTillDone::Application.routes.draw do

  devise_for :users, :controllers => { :registrations => 'qtdregistrations' }
  resources :users do
    collection do
      get 'github_authorize', 'github_callback' ,'github_list', 'github_project_import', 'github_project_del', 'github_update','restart_countdown', 'index', 'show', 'settings', 'get_td_json', 'github_revoke', 'dismiss'
      put 'update_config'
    end
  end
  get 'welcome/index'

  resources :encounters do
    collection do
      get 'get_user_timeline'
      post 'setState'
    end
  end

  resources :records do
    get :autocomplete_quest_name, :on => :collection
    get 'modify'
    get 'download', on: :member
  end

  resources :links, :controller => "records", :type => "Link"
  resources :notes, :controller => "records", :type => "Link"
  resources :images, :controller => "records", :type => "Link"

  resources :timers do
    collection do
      get 'get_time_current', 'get_time_setting', 'reset_countdown', 'restart_countdown', 'extend_countdown', 'break_countdown'
      post 'start_countdown', 'pause_countdown', 'change_mode'
    end
  end

  resources :quests do
    post 'destroy_softly', on: :member
    member do
      get 'toggle_state'
    end
    collection do
      get 'getTree'
      post 'set_active'
    end
  end
  resources :campaigns do
    collection do
      get 'getTree', 'get_campaign_timeline', 'timeline'
      post 'set_quest_parent'
    end
  end

  resources :priorities do
    collection do
      get 'get_priorities', 'get_all_priorities'
    end
  end

  resources :searches do
    collection do
      get 'quest_autocomplete', 'all_autocomplete', 'user_autocomplete'
    end
  end

  resources :groups do
    collection do
      get 'promote', 'timeline', 'demote'
      get 'accept/:id/:invite_id' => 'groups#accept'
      get 'reject/:id/:invite_id' => 'groups#reject'

    end

  end

  resource :group do
    collection do
      get ':id/kick' => 'groups#kick'
      get ':id/invite_user' => 'groups#invite_user'
      get ':id/leave' => 'groups#leave'
    end
  end

  resources :notifications do
    get 'reply', 'trashbin', 'group_kick', 'group_invite', 'group_promote'
  end


  mount Sidekiq::Web, at: '/jobs'

  #get '/project', to: redirect('/')

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

  resources :messages do
    member do
      post :new
    end
  end
  resources :conversations do
    member do
      post :reply
      post :trash
      post :untrash
    end
    collection do
      get :trashbin
      post :empty_trash
    end
  end


 # match "/u/:username" => "users#show", as: :user_profile, constraints: { username: /.*/ }, via: :get

end
