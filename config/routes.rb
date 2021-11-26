Rails.application.routes.draw do
  devise_for :users
  resources :users, only: [:index, :show, :edit, :update, :destroy] do
    resource :relations, only: [:create, :destroy]
    get 'following' => 'relations#following', as: 'following'
    get 'followers' => 'relations#followers', as: 'followers'
  end

  root to: 'homes#top'
  resources :posts, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
    resource :likes, only: [:create, :destroy]
    resource :stocks, only: [:create, :destroy]
  end
  get 'following-posts' => 'posts#following_posts', as: 'following_posts'
  get 'liked' => 'likes#liked_posts', as: 'liked_posts'
  get 'stocked' => 'stocks#stocked_posts', as: 'stocked_posts'
end
