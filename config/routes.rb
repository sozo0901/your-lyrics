Rails.application.routes.draw do
  get 'chats/show'
  devise_for :users
  root to: 'homes#top'
  resources :posts, only: [:new, :create, :index, :show, :destroy] do
    resource :likes, only: [:create, :destroy]
    resource :stocks, only: [:create, :destroy]
  end
  resources :users, only: [:index, :show, :edit, :update] do
    resource :relations, only: [:create, :destroy]
    get 'following' => 'relations#following', as: 'following'
    get 'followers' => 'relations#followers', as: 'followers'
  end
  
  get 'chat/:id' => 'chats#show', as: 'chat'
  resources :chats, only: [:create]


end
