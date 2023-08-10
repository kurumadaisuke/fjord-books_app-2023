# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :report_mention, dependent: :destroy
  has_many :mentioning_reports, through: :report_mention, source: :mention
  has_many :mentioned_reports_relationships, class_name: 'ReportMention', foreign_key: 'mention_id', dependent: :destroy, inverse_of: :mention
  has_many :mentioned_reports, through: :mentioned_reports_relationships, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end
end
