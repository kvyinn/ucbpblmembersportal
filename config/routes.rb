Ucbpblmembersportal::Application.routes.draw do
  root to: "sessions#new"

  match "/auth/:provider/callback", to: "sessions#create", as: :signin
  match "/signout", to: "sessions#destroy", :as => :signout
  match "/update/:old_member_id", to: "members#update", as: :update_with_old_member


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

  resources :tabling_slots, only: [ :index ] do
    get :generate, on: :collection
  end

  resources :commitment_calendars, only: [ :index, :create, :destroy ] do
    get :write, on: :collection
  end

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

end
