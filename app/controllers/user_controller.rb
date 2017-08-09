class UserController < ApplicationController

  skip_before_action :verify_authenticity_token

  def login
    user = User.find_by(name: params[:name])
    if user
      if user.authenticate(params[:password])
        user.update(logged_in: true)
        render :json => "you're logged in!".to_json
      else
        render :json => "invalid password for user with name #{params[:name]}".to_json
      end
    else
      render :json => "no user with name: #{params[:name]}".to_json
    end
  end

  def check_approval_queue
    user = User.find_by(id: params[:id])
    if user
      if user.admin
        if ((Time.now.utc - user.updated_at.utc)/60 > 60) || !user.logged_in
          # its been more than 60 mins, make them auth again
          user.update(logged_in: false)
          render :json => "your session expired, please authenticate again".to_json
        else
          render :json => Comment.where(approved: nil).to_json
        end
      else
        render :json => "hey, you're no admin!".to_json
      end
    else
      render :json => "no user with provided id #{params[:id]}".to_json
    end
  end

  def approve_comments
    user = User.find_by(id: params[:id])
    if user
      if user.admin
        if ((Time.now.utc - user.updated_at.utc)/60 > 60) || !user.logged_in
          # its been more than 60 mins, make them auth again
          user.update(logged_in: false)
          render :json => "your session expired, please authenticate again".to_json
        else
          if params[:comment_ids]
            # TODO - error handling for comment id's w/o a corresponding comment + for malformatted comment_ids param
            ids_with_no_comment = []
            approved_comments = []
            params[:comment_ids].split(",").each do |id|
              comment_to_approve = Comment.find_by(id: id)
              if comment_to_approve
                comment_to_approve.update(approved: true)
                approved_comments << comment_to_approve.content
              else
                ids_with_no_comment << id
              end
            end
            render :json => "Approved the following comments: #{approved_comments.to_json}. Couldn't find comments for the following id's: #{ids_with_no_comment.to_json}".to_json
          else
            render :json => "no comment_ids param provided".to_json
          end
        end
      else
        render :json => "hey, you're no admin!".to_json
      end
    else
      render :json => "no user with provided id #{params[:id]}".to_json
    end
  end

end
