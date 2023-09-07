# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mention, dependent: :destroy
  has_many :mentioning_reports, through: :report_mention, source: :mention
  has_many :mention_targets, class_name: 'ReportMention', foreign_key: 'mention_id', dependent: :destroy, inverse_of: :mention
  has_many :mentioned_reports, through: :mention_targets, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def create_with_mentions
    Report.transaction do
      content.include?('http://localhost:3000') ? save && create_mentions : save
    end
  end

  def create_mentions
    mention_urls = content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      mention_report_id = url.split('/').last.to_i
      mention = ReportMention.new(report_id: id, mention_id: mention_report_id)
      mention.save
    end
  end

  def update_with_mentions(report_params)
    Report.transaction do
      content.include?('http://localhost:3000') ? update(report_params) && update_mentions : update(report_params)
    end
  end

  def update_mentions
    ReportMention.where(report_id: id).destroy_all
    create_mentions
  end
end
