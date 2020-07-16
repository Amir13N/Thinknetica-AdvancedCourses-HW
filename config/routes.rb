# frozen_string_literal: true

Rails.application.routes.draw do
  devise_for :users

  resources :questions do
    resources :answers, shallow: true do
      patch :choose_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'
end
