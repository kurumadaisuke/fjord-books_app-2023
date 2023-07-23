# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase

  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @alices_report = reports(:one)
    @bobs_report = reports(:two)
  end

  test "editable?" do
    assert_equal true, @alices_report.editable?(@alice)
    assert_equal false, @alices_report.editable?(@bob)
  end

  test "created_on" do
    @alices_report.created_at = '2023-01-01 11:11'
    assert_equal '2023-01-01 11:11'.to_date, @alices_report.created_on
  end

  test "save_mentions" do
    no_mention_report = reports(:one)
    mentions_report = reports(:two)
    assert_equal [], no_mention_report.save_mentions
    assert_equal [], mentions_report.save_mentions
  end
end
