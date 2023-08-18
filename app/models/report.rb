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

  after_create :mention_reports_create
  after_update :mention_reports_update

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def mention_reports_create
    return unless content.include?('http://localhost:3000')

    mention_urls = content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      mention_id = url.split('/').last.to_i
      mention = ReportMention.new(report_id: id, mention_id: mention_id)
      mention.save
    end
  end

  def mention_reports_update
    return unless content.include?('http://localhost:3000')

    mention_urls = content.scan(%r{http://localhost:3000/reports/\d+}).uniq
    mention_urls.each do |url|
      mention_id = url.split('/').last.to_i
      ReportMention.update(report_id: id, mention_id: mention_id)
    end
  end

end
