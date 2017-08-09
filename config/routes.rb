Rails.application.routes.draw do

  # READ ALL DOCS
  root 'doctor#index'

  # READ COMMENTS ON A DOC
  get '/doctors/:id/comments', to: 'doctor#get_comments'

  # ADD COMMENT TO A DOC (WITH FORM PARAMS)
  post '/doctors/:id/comments', to: 'doctor#add_comment'

  # DELETE A COMMENT
  post '/doctors/:id/comments/:comment_id/destroy', to: 'doctor#delete_comment'

  # SWITCH ACTIVE STATUS OF A COMMENT
  post '/doctors/:id/comments/:comment_id/switch_active', to: 'doctor#switch_active'


end
