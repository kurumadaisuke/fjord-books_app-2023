# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def create
    @report = Report.new(report_params)
    @report.user_id = current_user.id

    respond_to do |format|
      if @report.save
        format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_create', name: Report.model_name.human) }
        format.json { render :show, status: :created, location: @report }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @report.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @report = Report.new
  end

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @comment = Comment.new
    @comments = @report.comments
  end

  def edit; end

  def update
    if @report.user != current_user
      redirect_to reports_path
    else
      respond_to do |format|
        if @report.update(report_params)
          format.html { redirect_to report_url(@report), notice: t('controllers.common.notice_update', name: Report.model_name.human) }
          format.json { render :show, status: :ok, location: @report }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @report.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def destroy
    if @report.user != current_user
      redirect_to reports_path
    else
      @report.destroy

      respond_to do |format|
        format.html { redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human) }
        format.json { head :no_content }
      end
    end
  end

  private

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def set_report
    @report = Report.find(params[:id])
  end
end
