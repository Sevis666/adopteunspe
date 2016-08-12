Rails.application.routes.draw do
  get '/', to: 'pages#index'
  get '/questions', to: 'pages#questions'
  get '/questions/new', to: 'pages#add_new_question'
  post '/questions/new', to: 'pages#add_new_question'
  get '/questions/:id', to: 'pages#modify_question'
  post '/questions/:id/comment', to: 'pages#comment_question'
  get '/public/sevisKey.asc', to: 'pages#serve_public_key'
  get '/login', to: 'pages#login'
  post '/login', to: 'pages#login'
end
