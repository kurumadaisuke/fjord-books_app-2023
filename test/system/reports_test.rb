# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    visit root_path
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test 'visiting the index' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test 'should create report' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: '初めての日報'
    fill_in '内容', with: 'フィヨルドブートキャンプのプラクティスは難しい'
    click_on '登録する'

    assert_text '日報が作成されました。'
    assert_text '初めての日報'
    assert_text 'フィヨルドブートキャンプのプラクティスは難しい'
    click_on '日報の一覧に戻る'

    assert_text '初めての日報'
    assert_text 'フィヨルドブートキャンプのプラクティスは難しい'
  end

  test 'should update Report' do
    report = reports(:alices_report)
    visit report_url(report)
    click_on 'この日報を編集', match: :first

    fill_in 'タイトル', with: '日報内容変更'
    fill_in '内容', with: 'フィヨルドブートキャンプのプラクティスを改定しました。'
    click_on '更新する'

    assert_text '日報が更新されました。'
    assert_text '日報内容変更'
    assert_text 'フィヨルドブートキャンプのプラクティスを改定しました。'
    click_on '日報の一覧に戻る'

    assert_text '日報内容変更'
    assert_text 'フィヨルドブートキャンプのプラクティスを改定しました。'
  end

  test 'should destroy Report' do
    report = reports(:alices_report)
    visit report_url(report)
    assert_text '今日の日報(アリス)'
    click_on 'この日報を削除', match: :first

    assert_text '日報が削除されました。'
    assert_no_text '今日の日報(アリス)'
    assert_selector 'h1', text: '日報の一覧'
  end
end
