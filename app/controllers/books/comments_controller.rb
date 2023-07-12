# frozen_string_literal: true

class Books::CommentsController < ApplicationController
  before_action :set_commentable

  def create
    @comment = @commentable.comments.build(comment_params)
    @comment.user = current_user
    if @comment.save
      redirect_to @commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      @comments = @commentable.comments
      render_commentable_show
    end
  end

  def destroy
    comment = Comment.find(params[:id])
    if comment.user != current_user
      redirect_to comment_url
    else
      comment.destroy
      flash[:notice] = 'コメントを削除しました'
      redirect_to comment_url
    end
  end

  private

  def set_commentable
    @commentable = Book.find(params[:book_id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
