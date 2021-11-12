Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :likes, only: [:create, :destroy]
    resource :stocks, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relations, only: [:create, :destroy]
    get 'following' => 'relations#following', as: 'following'
    get 'followers' => 'relations#followers', as: 'followers'
  end

  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]


end
