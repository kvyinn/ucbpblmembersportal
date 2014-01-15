Ucbpblmembersportal::Application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  root to: "home#home"

  get "/auth/google_oauth2", as: :google_signin
  match "/auth/:provider/callback", to: "sessions#create", as: :signin
  match "/signout", to: "sessions#destroy", :as => :signout
  match "/update/:old_member_id", to: "members#update", as: :update_from_old_member

  get :rankings, to: "points#rankings", as: :rankings # TODO: move to "committees#rankings"

  # routes added by david
  match "/tabling/options", to: "tabling_slots#tabling_options"
  match "/tabling/generate", to: "tabling_slots#generate_tabling"
  # end of david routes

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
  end

  resources :members, only: [ :show ] do
    resources :reimbursements, only: [ :new ]
  end

  resources :tabling_slots, only: [ :index, :show ] do
    get :print, on: :collection
    get :generate, on: :collection
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
    end
  end

  resources :points, only: [ :index ]
  resources :event_points, only: [ :index ] do
    post :update_all, on: :collection
  end
end
