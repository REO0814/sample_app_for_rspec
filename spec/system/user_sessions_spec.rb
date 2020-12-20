require 'rails_helper'

RSpec.describe "UserSessions", type: :system do
  include LoginSupport
  let!(:user) { create(:user) }
  describe 'ログイン' do
    describe 'ログインページ' do
      before do
        visit root_path
        click_link 'Login'
      end
      context 'フォームの入力値が正常' do
        it 'ログインできる' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          click_button 'Login'
          expect(page).to have_content 'Login successful'
          expect(page).to have_content 'Tasks'
          expect(page).to have_current_path root_path
        end
      end
      context 'メールアドレスが未入力' do
        it 'ログイン失敗する' do
          fill_in 'Email', with: ''
          fill_in 'Password', with: ''
          click_button 'Login'
          expect(page).to have_content 'Login failed'
        end
      end
    end
    describe 'ログアウト' do
      it 'ログアウトできる' do
        sign_in_as(user)
        click_link 'Logout'
        expect(page).to have_content 'Logged out'
      end
    end
    describe 'ログイン前のアクセス制御' do
      before { visit root_path }
      context 'マイページ' do
        it 'アクセスできない' do
          visit user_path(user)
          expect(page).to have_content 'Login required'
          expect(page).to have_current_path login_path
        end
      end
      context 'タスクの新規作成' do
        it 'アクセスできない' do
          visit new_task_path
          expect(page).to have_content 'Login required'
          expect(page).to have_current_path login_path
        end
      end
    end
  end
end
