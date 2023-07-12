# frozen_string_literal: true

class CommentsController < ApplicationController
  def destroy
    comment = Comment.find(params[:id])
    return if comment.user != current_user

    comment.destroy
    flash[:notice] = 'コメントを削除しました'
    redirect_to request.referer
  end
end
