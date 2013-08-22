Ucbpblmembersportal::Application.routes.draw do
  root to: "sessions#new"

  match "/auth/:provider/callback", to: "sessions#create"
  match "/signout", to: "sessions#destroy", :as => :signout

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

  resources :tabling_slots, only: [ :index ]

  resources :commitment_calendars, only: [ :index, :create, :destroy ]

  resources :committees, only: [ :show ] do
    resources :reimbursements, only: [ :new ]
  end

  resources :reimbursements, only: [ :index, :show, :new, :create, :destroy ]
end