ImpoundPro::Application.routes.draw do
  constraints(:subdomain => "secure") do
    resources :trims

    resources :years

    resources :models do
      resources :years do
        resources :trims
      end
    end

    resources :makes do
      resources :models
    end

    resources :password_resets

    controller :sessions do
      get 'login' => :new

      post 'login' => :create

      delete 'logout' => :destroy

      get 'logout' => :destroy
    end

    resource :user do
      get 'subscribe' => :subscribe
    end

    match 'cars/unclaimed_vehicles_report' => 'cars#unclaimed_vehicles_report'

    get 'reports' => 'secure#reports'

    resources :cars do
      member do
        get 'unlock'
        get 'owner_lien_notice'
        get 'lien_holder_lien_notice'
        get 'driver_lien_notice'
        get 'owner_mail_labels'
        get 'lien_holder_mail_labels'
        get 'driver_mail_labels'
        get 'notice_of_public_sale'
        get 'affidavit_of_resale'
        get 'title_application'
        get 'fifty_state_check'
      end

      resources :lien_procedures
    end

    match "/" => 'secure#dashboard'
  end

  post 'stripe_webhook' => 'stripe_webhooks#create'

  controller :landing do
    get 'home'
    get 'tour'
    get 'pricing'
  end

  match "login" => redirect(:subdomain => "secure")

  root :to => 'landing#home'

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
  # root :to => 'welcome#index'

  # See how all your routes lay out with "rake routes"

  # This is a legacy wild controller route that's not recommended for RESTful applications.
  # Note: This route will make all actions in every controller accessible via GET requests.
  # match ':controller(/:action(/:id))(.:format)'

end
