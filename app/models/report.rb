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

  # after_update :mention_reports_update

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  def self.create_report_with_mentions(user, report_params)
    report = user.reports.new(report_params)

    Report.transaction do
      raise ActiveRecord::Rollback unless report.save!

      if report.content.include?('http://localhost:3000')
        mention_urls = report.content.scan(%r{http://localhost:3000/reports/\d+}).uniq
        mention_urls.each do |url|
          mention_report_id = url.split('/').last.to_i
          mention = ReportMention.new(report_id: report.id, mention_id: mention_report_id)
          raise ActiveRecord::Rollback unless mention.save
        end
      end
    end

    report
  end

  def self.update_report_with_mentions(report, report_params)
    Report.transaction do
      raise ActiveRecord::Rollback unless report.update!(report_params)

      if report.content.include?('http://localhost:3000')
        mention_urls = report.content.scan(%r{http://localhost:3000/reports/\d+}).uniq
        mention_urls.each do |url|
          mention_report_id = url.split('/').last.to_i
          ReportMention.update!(report_id: report.id, mention_id: mention_report_id)
        end
      end
    end
  end
end
