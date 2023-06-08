# frozen_string_literal: true

class Book < ApplicationRecord
  mount_uploader :picture, PictureUploader
  def localized_action_message
    self.class.name.downcase
  end
end
