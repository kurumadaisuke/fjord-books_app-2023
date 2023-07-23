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
    no_mention_report = Report.create(
      user: users(:alice),
      title: "no_mention_report",
      content: "no_mention_report"
    )

    one_mention_report = Report.create(
      user: users(:alice),
      title: "one_mention_report",
      content: "http://localhost:3000/reports/#{no_mention_report.id}"
    )

    two_mention_report = Report.create(
      user: users(:alice),
      title: "two_mention_report",
      content: "http://localhost:3000/reports/#{no_mention_report.id},
                http://localhost:3000/reports/#{one_mention_report.id}"
    )

    assert_equal [],                                      no_mention_report.mentioning_reports
    assert_equal [no_mention_report],                     one_mention_report.mentioning_reports
    assert_equal [no_mention_report, one_mention_report], two_mention_report.mentioning_reports
  end
end
