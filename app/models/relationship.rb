# frozen_string_literal: true

class Relationship < ApplicationRecord
  belongs_to :report
  belongs_to :mention, class_name: 'Report'

  validates :report_id, presence: true
  validates :mention_id, presence: true
end
