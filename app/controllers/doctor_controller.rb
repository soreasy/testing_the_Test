class DoctorController < ApplicationController

  def get_comments
    doc = Doctor.find(params[:id])
    if doc
      # return all comments on them
      all_comments = doc.comments
      all_comment_text = all_comments.map{ |comment| comment.content }

      # render :json => all_comment_text.to_json
      render :json => {success: true}
    else
      # return no doctor with that id message
      # render :json => "no doctor with provided id #{params[:id]}".to_json
      render :json => {success: true}
    end
  end

  def index
    
  end

end
