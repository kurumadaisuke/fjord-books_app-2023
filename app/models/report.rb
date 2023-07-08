# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :relationships, dependent: :destroy
  has_many :mentioning_reports, through: :relationships, source: :mention
  has_many :reverse_of_relationships, class_name: 'Relationship', foreign_key: 'mention_id'
  has_many :mentioned_reports, through: :reverse_of_relationships, source: :report

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

end
