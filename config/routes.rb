require 'constraints/api_version'

Rails.application.routes.draw do

  mount Ckeditor::Engine => '/ckeditor'

  namespace :admin do
    with_options only: %i(index create new show edit update destroy) do |o|
      o.resources :vendors do
        resources :images, only: %i(create destroy)
      end
      o.resources :customers
      o.resources :holidays
      o.resources :orders
      o.resources :order_items
      o.resources :items
      o.resources :item_types
      o.resources :services
      o.resources :inventory_items
      o.resources :shippings
      o.resources :shipping_methods
      o.resources :shipping_method_names
      o.resources :shipping_addresses
      o.resources :reviews
      o.resources :comments
      o.resources :credit_transactions
      o.resources :addresses
      o.resources :pages
      o.resources :promotions
      o.resources :promotion_rules
      o.resources :promotion_actions
      namespace :promotion do
        namespace :rules do
          o.resources :order_totals
          o.resources :order_item_discounts
          o.resources :order_item_quantities
        end
        namespace :actions do
          o.resources :create_adjustments
          o.resources :create_item_adjustments
        end
      end
      o.resources :payouts
      o.resources :schedules
      o.resources :payments
      o.resources :cards
    end
    resources :reports do
      collection do
        get :vendor_transactions
        post :search_vendor_transactions
        post :export_transactions
        get :vendor_orders
        post :search_vendor_orders
        post :export_orders
      end
    end

    resources :uploads, only: %i(index) do
      collection do
        post :vendor_details
      end
    end
    root to: "vendors#index"
  end

  namespace :api, path: '/',
                  defaults: { format: :json },
                  constraints: Constraints::ApiSubdomain.new do
    # TODO: make namespaces from scopes
    scope(module: :v2, constraints: Constraints::ApiVersion.new(version: 'v2', default: false)) do
      resource :api_version_tests, only: :show
    end

    scope(module: :v1, constraints: Constraints::ApiVersion.new(version: 'v1', default: true)) do
      get '/', to: redirect('/docs/api/v1')

      scope(module: :user) do
        resource :signin, only: :create do
          get 'fetch_user/:id', action: :fetch_user, on: :member
        end
        resource :social_signin, only: :create
        resource :signup, only: :create
        resource :signout, only: :destroy
        resources :activations, only: [:edit]
        resources :password_resets, only: [:create, :edit]
        patch 'password_resets', to: 'password_resets#update'
      end

      scope(module: :geocoding) do
        resource :near_vendors, only: [:show] do
          member do
            get :map
          end
        end
      end

      resources :addresses, only: %i(index create show update destroy)
      resources :credits, only: :index, module: :customer

      resources :customers, only: [:show, :update] do
        member do
          get :reviews
        end
      end
      namespace :customer do
        resources :orders, only: :index
        resource :last_order, only: :show
      end

      resources :orders, only: %i(create show)
      resources :openbasket_orders, only: %i(create update)
      resources :order_states, only: [:show, :update]
      resource :cart, only: :create

      namespace :vendor do
        resources :orders
        resources :search, only: :index
        resources :dashboards, only: :index
        resource :balance, only: :show
        resource :monthly_incomes, only: :show
      end

      resources :vendors, only: [:index, :show, :create, :update] do
        resources :inventory_items, only: :index do
          collection do
            get :services
            get :items
            get :item_types
          end
        end
        member do
          get :reviews
          get :shipping_methods
          get :schedule
        end
      end

      scope(module: :review) do
        resources :reviews, only: [:create, :show] do
          resource :likes, only: [:create, :destroy]
          resources :comments, only: [:create, :update, :destroy]
        end
      end

      scope(module: :payment_gateway) do
        resources :customers, only: :create do
          get :cards # callback from payfort
        end
        resources :cards, only: [:index, :create, :destroy, :show]
        resources :purchases, only: :create do
          post :by_credits, on: :collection
        end
        resources :payments, only: [:create, :show] do
          post :cash, on: :collection
          get :completion, on: :collection
        end
      end

      namespace :catalog do
        resources :items, only: :index
        resources :item_types, only: :index
        resources :services, only: :index
      end

      resources :pages, only: :show
      scope(module: :pushes) do
        resources :notification_registrations, only: [:create, :destroy]
        resources :notification_messages, only: [:index, :create]
      end

      resources :promotions, only: :index

      resource :api_version_tests, only: :show

    end # v1 scope
  end # api namespace

end
