class ChangeRelationshipToReportMention < ActiveRecord::Migration[7.0]
  def change
    rename_table :relationships, :report_mentions
  end
end
