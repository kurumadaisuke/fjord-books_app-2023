# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mention, dependent: :destroy
  has_many :mentioning_reports, through: :report_mention, source: :mention
  has_many :mentioned_reports, class_name: 'ReportMention', foreign_key: 'mention_id', dependent: :destroy, inverse_of: :mention
  has_many :mentioned_reports, through: :mentioned_reports, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention_reports_create
    return unless @report.content.include?('http://localhost:3000')
    mention_urls = @report.content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      id = url.split('/').last.to_i
      mention = ReportMention.new(report_id: @report.id, mention_id: id)
      mention.save
    end
  end
end
