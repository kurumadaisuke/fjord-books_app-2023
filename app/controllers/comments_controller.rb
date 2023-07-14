# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    comment = Comment.find(params[:id])
    type_path = comment.commentable_type.downcase
    return if comment.user != current_user
    comment.destroy
    flash[:notice] = 'コメントを削除しました'
    redirect_to comment_path(id: comment.commentable_id)
  end
end
