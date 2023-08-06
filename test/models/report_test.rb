# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  setup do
    @alice = users(:alice)
    @bob = users(:bob)
    @alices_report = reports(:alices_report)
    @bobs_report = reports(:bob_report)
  end

  test 'editable?' do
    assert @alices_report.editable?(@alice)
    assert_equal false, @alices_report.editable?(@bob)
  end

  test 'created_on' do
    @alices_report.created_at = Time.current
    assert_equal Time.current.to_date, @alices_report.created_on
  end

  test 'save_mentions' do
    no_mention_report = @alice.reports.create!(
      user: users(:alice),
      title: 'no_mention_report',
      content: 'no_mention_report'
    )

    one_mention_report = @alice.reports.create!(
      user: users(:alice),
      title: 'one_mention_report',
      content: "http://localhost:3000/reports/#{no_mention_report.id}"
    )

    two_mention_report = @alice.reports.create!(
      user: users(:alice),
      title: 'two_mention_report',
      content: <<~TEXT
        http://localhost:3000/reports/#{no_mention_report.id},
        http://localhost:3000/reports/#{one_mention_report.id}
      TEXT
    )

    assert_equal [], no_mention_report.mentioning_reports
    assert_equal [no_mention_report], one_mention_report.mentioning_reports
    assert_equal [no_mention_report, one_mention_report], two_mention_report.mentioning_reports
  end

  test 'update_save_mentions' do
    no_mention_report = @alice.reports.create!(
      user: users(:alice),
      title: 'no_mention_report',
      content: 'no_mention_report'
    )

    default_report = @alice.reports.create!(
      user: users(:alice),
      title: 'default_report',
      content: 'default_report'
    )

    no_mention_report.update(
      title: 'update_mention_report',
      content: "http://localhost:3000/reports/#{default_report.id}"
    )
    assert_equal [default_report], no_mention_report.mentioning_reports
  end

  test 'delete_mentions' do
    default_report = @alice.reports.create!(
      user: users(:alice),
      title: 'default_report',
      content: 'default_report'
    )

    mention_report = @alice.reports.create!(
      user: users(:alice),
      title: 'one_mention_report',
      content: "http://localhost:3000/reports/#{default_report.id}"
    )

    assert_includes default_report.mentioned_reports, mention_report
    mention_report.destroy
    assert_not_includes default_report.mentioned_reports, mention_report
  end
end
