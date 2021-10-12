# frozen_string_literal: true

Rails.application.routes.draw do
  defaults format: :json do
    resources :tasks, except: %i[new edit], param: :slug
    resources :users, only: %i[index create]
  end
  root "home#index"
  get "*path", to: "home#index", via: :all
end
