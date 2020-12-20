require 'rails_helper'

RSpec.describe "Users", type: :system do
  include LoginSupport
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user, email: 'other@foo.com') }
  let(:task) { build(:task) }
  describe 'ログイン前' do
    describe 'ユーザー新規登録' do
      before do
        visit sign_up_path
      end
      context 'フォームの入力値が正常' do
        it 'ユーザーの新規作成が成功する' do
          fill_in 'Email', with: 'hoge@foo.com'
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          expect(page).to have_current_path login_path
          expect(page).to have_content 'User was successfully created.'
        end
      end
      
      context 'メールアドレスが未入力' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          # expect(page).to have_current_path sign_up_path
          expect(page).to have_content "Email can't be blank"
        end
      end
      
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの新規作成が失敗する' do
          fill_in 'Email', with: user.email
          fill_in 'Password', with: 'password'
          fill_in 'Password confirmation', with: 'password'
          click_button 'SignUp'
          # expect(page).to have_current_path sign_up_path
          expect(page).to have_content "Email has already been taken"
          expect(page).to have_field 'Email', with: user.email
        end
      end
    end
    
    describe 'マイページ' do
      context 'ログインしていない状態' do
        it 'マイページへのアクセスが失敗する' do
          visit root_path
          visit user_path(user)
          expect(page).to have_current_path login_path
          expect(page).to have_content 'Login required'
        end
      end
    end
  end
  
  describe 'ログイン後' do
    before do
      sign_in_as(user) 
    end
    describe 'ユーザー編集' do
      context 'フォームの入力値が正常' do
        it 'ユーザーの編集が成功する' do
          click_link 'Mypage'
          click_link 'Edit'
          expect(page).to have_field 'Email', with: user.email
          fill_in 'Email', with: 'edit@foo.com'
          fill_in 'Password', with: 'edit_password'
          fill_in 'Password confirmation', with: 'edit_password'
          click_button 'Update'
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content 'User was successfully updated.'
          expect(page).to have_content 'edit@foo.com'
        end
      end
      context 'メールアドレスが未入力' do
        it 'ユーザーの編集が失敗する' do
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: ''
          fill_in 'Password', with: 'edit_password'
          fill_in 'Password confirmation', with: 'edit_password'
          click_button 'Update'
          expect(page).to have_current_path user_path(user)
          expect(page).to have_content "Email can't be blank"
        end
      end
      context '登録済のメールアドレスを使用' do
        it 'ユーザーの編集が失敗する' do
          click_link 'Mypage'
          click_link 'Edit'
          fill_in 'Email', with: other_user.email
          fill_in 'Password', with: 'edit_password'
          fill_in 'Password confirmation', with: 'edit_password'
          click_button 'Update'
          # expect(page).to have_current_path user_path(user)
          expect(page).to have_content "Email has already been taken"
          expect(page).to have_field 'Email', with: other_user.email
        end
      end
      context '他ユーザーの編集ページにアクセス' do
        it '編集ページへのアクセスが失敗する' do
          visit edit_user_path(other_user)
          expect(page).to have_content 'Forbidden access.'
        end
      end
    end

  end
end
