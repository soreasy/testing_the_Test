class DoctorController < ApplicationController

  def index
    render :json => Doctor.all.to_json
  end

  def get_comments
    doc = Doctor.find(params[:id])
    if doc
      # return all comments on them
      all_comments = doc.comments
      all_comment_text = all_comments.map{ |comment| {comment_text: comment.content, active: comment.active} }

      render :json => all_comment_text.to_json
    else
      # return no doctor with that id message
      render :json => "no doctor with provided id #{params[:id]}".to_json
    end
  end

  def add_comment
    doc_to_comment_on = Doctor.find(params[:id])
    if doc_to_comment_on
      if params[:comment]
        doc_to_comment_on.comments << Comment.create(active: true, content: params[:comment])
        render :json => "added your comment!".to_json
      else
        render :json => "please provide a comment".to_json
      end
    else
      # return no doctor with that id message
      render :json => "no doctor with provided id #{params[:id]}".to_json
    end
  end

  def delete_comment
    comment_to_delete = Comment.find(params[:comment_id])
    if comment_to_delete
      comment_to_delete.destroy
      render :json => "deleted the comment!".to_json
    else
      render :json => "no comment with id #{params[:comment_id]}".to_json
    end
  end

  def switch_active
    comment_to_switch = Comment.find(params[:comment_id])
    if comment_to_switch
      comment_to_switch.update(active: !comment_to_switch.active)
      render :json => "comment with id #{params[:comment_id]} is now #{comment_to_switch.active ? 'active' : 'inactive'}".to_json
    else
      render :json => "no comment with id #{params[:comment_id]}".to_json
    end
  end

end
