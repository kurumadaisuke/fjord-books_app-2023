# frozen_string_literal: true

class CommentsController < ApplicationController
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
    if @report.user != current_user
      redirect_to reports_path
    else
      comment = Comment.find(params[:id])
      comment.destroy
      flash[:notice] = 'コメントを削除しました'
      redirect_to book_path
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
