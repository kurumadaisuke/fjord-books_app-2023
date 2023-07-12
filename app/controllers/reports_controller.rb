# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[edit update destroy]

  def index
    @reports = Report.includes(:user).order(id: :desc).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @mentions = Relationship.where(mention_id: params[:id]).order(id: :desc)
  end

  # GET /reports/new
  def new
    @report = current_user.reports.new
  end

  def edit; end

  def create
    @report = current_user.reports.new(report_params)

    if @report.save
      mention_reports_create
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @report.update(report_params)
      mention_reports_update
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy

    redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human)
  end

  private

  def set_report
    @report = current_user.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :content)
  end

  def mention_reports_create
    return unless @report.content.include?('http://localhost:3000')

    mention_urls = @report.content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      id = url.split('/').last.to_i
      mention = Relationship.new(report_id: @report.id, mention_id: id)
      mention.save
    end
  end

  def mention_reports_update
    return unless @report.content.include?('http://localhost:3000')

    mention_urls = @report.content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      id = url.split('/').last.to_i
      Relationship.update(report_id: @report.id, mention_id: id)
    end
  end
end
