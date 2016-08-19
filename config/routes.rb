Rails.application.routes.draw do
  get '/', to: 'pages#index'
  get '/questions', to: 'pages#questions'
  get '/questions/new', to: 'pages#add_new_question'
  post '/questions/new', to: 'pages#add_new_question'
  get '/questions/:id', to: 'pages#modify_question', constraints: {id: /\d+/}
  post '/questions/:id/comment', to: 'pages#comment_question'
  post '/questions/:id/vote', to: 'pages#vote_question'
  get '/questions/unvoted', to: 'pages#questions_unvoted'
  get '/questions/unanswered', to: 'pages#questions_unanswered'
  get '/questions/unrated', to: 'pages#questions_unrated'
  get '/public/sevisKey.asc', to: 'pages#serve_public_key'
  get '/message_board', to: 'pages#message_board'
  get '/login', to: 'pages#login'
  post '/login', to: 'pages#login'
end
