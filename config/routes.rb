Ucbpblmembersportal::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "home#home"
  match "/auth/facebook/callback", to: "deliberations#facebook"
  get "/auth/google_oauth2", as: :google_signin
  match "/auth/google_oauth2/callback", to: "sessions#create", as: :signin
  match "/signout", to: "sessions#destroy", :as => :signout
  match "/update/:old_member_id", to: "members#update", as: :update_from_old_member

  get :rankings, to: "points#rankings", as: :rankings # TODO: move to "committees#rankings"

  # ad hoc route for events
  match "/new_events", to: "events#new_index"
  match "/new_events/:id", to: "events#new_show"
  # ad hoc deliberations routs
  # TODO clean this up this is a mess
  match "/rankings/:committee/:delib_id", to: "applicant_rankings#new_committee"
  match "/rankings/submitall", to: "applicant_rankings#submitall"
  match "/deliberations/deliberate/:delib_id", to: "deliberations#run_deliberations"
  match "/deliberate/links/:delib_id", to: "deliberations#get_delib_links"
  match '/deliberations/add_applicant_image/', to: "applicants#add_image"
  match "/deliberations/data", to: "deliberations#deliberations_data"
  match "/deliberations/assign", to: "deliberations#make_assignment"
  match "newtable/:committee/:delib_id", to: "applicant_rankings#new_table"
  resources :applicant_rankings
  resources :applicants
  resources :deliberations

  resource :posts

  resources :calendars, only: [ :index, :show ] do
    member do
      get :clear
      get :confirm_clear
    end

    resources :events, only: [ :show, :index ]

  end

  resources :events, only: [ :show, :index ] do
    member do
      resources :event_members, only: [ :create, :destroy ]
      resources :members, only: [ :index ]
    end
    collection do
      get :sync_events_with_google
    end
  end

  resources :members, only: [ :show ] do
    resources :reimbursements, only: [ :new ]
  end

  resources :tabling_slots, only: [ :index, :show ] do
    # get :print, on: :collection
    # get :generate, on: :collection
    collection do
      get :tabling_options
      get :generate_tabling
      get :print
      get :generate
      get :delete_slots
    end
  end

  resources :tabling_slot_members, only: [ :create, :destroy, :update ] do
    put :set_status_for, on: :member
  end

  resources :commitment_calendars, only: [ :index, :create, :destroy ]

  resources :committees, only: [ :show ] do
    resources :reimbursements, only: [ :new ]
  end

  resources :reimbursements, only: [ :index, :show, :new, :create, :destroy ]

  resources :commitments, only: [ :index ] do
    collection do
      get :update_all
      get :preview
      get :availability
      get :update_availability
    end
  end

  resources :points, only: [ :index ] do
    collection do
      get :d3_points
      get :get_d3_data
    end
  end
  resources :event_points, only: [ :index ] do
    post :update_all, on: :collection
  end
end
