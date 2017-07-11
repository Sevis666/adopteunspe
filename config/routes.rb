Rails.application.routes.draw do
  get '/', to: 'pages#root'
  get '/index', to: 'pages#index'
  get '/questions', to: 'pages#questions'
  get '/questions/new', to: 'pages#add_new_question'
  post '/questions/new', to: 'pages#add_new_question'
  get '/questions/:id', to: 'pages#modify_question', constraints: {id: /\d+/}
  post '/questions/:id/comment', to: 'pages#comment_question'
  post '/questions/:id/vote', to: 'pages#vote_question'
  get '/questions/unvoted', to: 'pages#questions_unvoted'
  get '/questions/unanswered', to: 'pages#questions_unanswered'
  get '/questions/unrated', to: 'pages#questions_unrated'
  get '/godson_answers', to: 'pages#godson_answers'
  get '/public/sevisKey.asc', to: 'pages#serve_public_key'
  get '/message_board', to: 'pages#message_board'
  get '/login', to: 'pages#login'
  post '/login', to: 'pages#login'

  get '/user_login', to: 'pages#user_login'
  post '/user_login', to: 'pages#register_user'
  get '/survey', to: 'pages#survey'
  post '/survey', to: 'pages#survey'

  post '/db/reset_users', to: 'processing#reset_users'
  post '/db/reset_godfathers', to: 'processing#reset_godfathers'
  post '/db/delete_user', to: 'processing#delete_user'
  post '/match_pairs', to: 'processing#match_pairs'
  post '/force_match', to: 'processing#force_match'

  get '/api/users', to: 'pages#users_list'
  post '/api/users', to: 'pages#users_list'

  get '/admin', to: 'admin#index'
  post '/admin/freeze', to: 'admin#freeze'
  post '/admin/balance', to: 'admin#balance'
end
