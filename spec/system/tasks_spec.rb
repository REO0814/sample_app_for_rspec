require 'rails_helper'

RSpec.describe "Tasks", type: :system do
  include LoginSupport
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, email: 'other@foo.com') }
  let(:task) { build(:task) }
  let!(:existing_task) { create(:task, title: 'other_title', user: user) }
  let!(:task_belongs_to_other_user) { create(:task, user: other_user) }
  describe 'ログイン前' do
    describe 'ページ遷移確認' do
      context 'タスクの新規登録ページにアクセス' do
        it '新規登録ページへのアクセスが失敗する' do
          visit new_task_path
          expect(page).to have_content('Login required')
          expect(current_path).to eq login_path
        end
      end
    end
  end
  describe 'マイページ' do
    before do
      sign_in_as(user) 
    end
    describe 'タスクを作成' do
      before do
        click_link 'New task'
      end
      context 'フォームの入力値が正常' do
        it '新規作成したタスクが表示される' do
          fill_in 'Title', with: task.title
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          fill_in 'Deadline', with: DateTime.new(2020, 2, 2, 1, 0)
          click_button 'Create Task'
          expect(page).to have_current_path task_path(task)
          expect(page).to have_content "Task was successfully created."
          expect(page).to have_content task.title
          expect(page).to have_content task.content
          expect(page).to have_content task.status
          expect(page).to have_content 'Deadline: 2020/2/2 1:0'
          click_link 'Mypage'
          expect(page).to have_content task.title
          expect(page).to have_content task.status
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成に失敗する' do
          fill_in 'Title', with: ''
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          # fill_in 'Deadline', with: task.deadline.strftime("00%Y/%m/%d %H:%M")
          fill_in 'Deadline', with: '00202012241010'
          click_button 'Create Task'
          # expect(page).to have_current_path task_path(task)
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_field 'Content', with: task.content
          expect(page).to have_select 'Status', selected: task.status
          # expect(page).to have_field 'Deadline', with: '2020/12/24 10:10'
        end
      end
      context 'タイトルが既に存在する' do
        it 'タスクの新規作成に失敗する' do
          other_task = create(:task)
          fill_in 'Title', with: other_task.title
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          # fill_in 'Deadline', with: task.deadline.strftime("00%Y/%m/%d %H:%M")
          fill_in 'Deadline', with: '00202012241010'
          click_button 'Create Task'
          # expect(page).to have_current_path task_path(task)
          expect(page).to have_content "Title has already been taken"
          expect(page).to have_field 'Content', with: task.content
          expect(page).to have_select 'Status', selected: task.status
          # expect(page).to have_field 'Deadline', with: '2020/12/24 10:10'
        end
      end
    end
    describe 'タスクの編集' do
      before do
        click_link 'Show', href: task_path(existing_task)
        click_link 'Edit', href: edit_task_path(existing_task)
      end
      context 'フォームの入力が正常値' do
        it 'タスクの編集に成功する' do
          expect(page).to have_field 'Title', with: existing_task.title
          expect(page).to have_field 'Content', with: existing_task.content
          expect(page).to have_select 'Status', selected: existing_task.status
          fill_in 'Title', with: 'Update title'
          click_button 'Update Task'
          expect(page).to have_current_path task_path(existing_task)
          expect(page).to have_content 'Task was successfully updated.'
          expect(page).to have_content 'Update title'
        end
      end
      context 'タイトルが未入力' do
        it 'タスクの新規作成に失敗する' do
          fill_in 'Title', with: ''
          fill_in 'Content', with: task.content
          select task.status, from: 'Status'
          # fill_in 'Deadline', with: task.deadline.strftime("00%Y/%m/%d %H:%M")
          # fill_in 'Deadline', with: '00202012241010'
          click_button 'Update Task'
          # expect(page).to have_current_path task_path(task)
          expect(page).to have_content "Title can't be blank"
          expect(page).to have_field 'Content', with: task.content
          expect(page).to have_select 'Status', selected: task.status
          # expect(page).to have_field 'Deadline', with: '2020/12/24 10:10'
        end
      end
      context '他ユーザーのタスク編集ページにアクセス' do
        it '編集ページのアクセスに失敗する' do
          visit edit_task_path(task_belongs_to_other_user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end
    describe 'タスクの削除' do
      it 'タスクの削除が成功する' do
        expect(page).to have_content existing_task.title
        click_link 'Destroy'
        page.accept_confirm
        expect(page).to have_content "Task was successfully destroyed."
        expect(page).to_not have_content existing_task.title
        expect(page).to have_current_path tasks_path
      end
    end
  end
end
