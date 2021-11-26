require 'rails_helper'

describe '[STEP1] ユーザログイン前のテスト' do
  describe 'トップ画面のテスト' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/'
      end
      it 'Sign upリンクが表示される' do
        sign_up_link = find_all('a')[3].native.inner_text
        expect(sign_up_link).to match(/Sign up/)
      end

      it 'Log inリンクが表示される' do
        log_in_link = find_all('a')[4].native.inner_text
        expect(log_in_link).to match(/Sign in/)
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしていない場合' do
    before do
      visit root_path
    end

    context '表示内容の確認' do
      it 'YourLyricsロゴリンクが表示される: 左上から1番目のリンクが「ロゴ」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(//)
      end
      it 'Sign upリンクが表示される: 左上から2番目のリンクが「Sign up」である' do
        signup_link = find_all('a')[1].native.inner_text
        expect(signup_link).to match(/Sign up/)
      end
      it 'Log inリンクが表示される: 左上から3番目のリンクが「Sign in」である' do
        login_link = find_all('a')[2].native.inner_text
        expect(login_link).to match(/Sign in/)
      end
    end

    context 'リンクの内容を確認' do
      subject { current_path }

      it 'YourLyricsを押すと、トップ画面に遷移する' do
        home_link = find_all('a')[0]
        is_expected.to eq '/'
      end
      it 'Sign upを押すと、新規登録画面に遷移する' do
        signup_link = find_all('a')[1].native.inner_text
        signup_link = signup_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link signup_link, match: :first
        is_expected.to eq '/users/sign_up'
      end
      it 'Sign inを押すと、ログイン画面に遷移する' do
        login_link = find_all('a')[2].native.inner_text
        login_link = login_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link login_link, match: :first
        is_expected.to eq '/users/sign_in'
      end
    end
  end

  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_up'
      end
      it '「Sign up」と表示される' do
        expect(page).to have_content 'Sign up'
      end
      it 'nameフォームが表示される' do
        expect(page).to have_field 'user[name]'
      end
      it 'emailフォームが表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'password_confirmationフォームが表示される' do
        expect(page).to have_field 'user[password_confirmation]'
      end
      it 'Sign upボタンが表示される' do
        expect(page).to have_button 'Sign up'
      end
    end

    context '新規登録成功のテスト' do
      before do
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
        fill_in 'user[email]', with: Faker::Internet.email
        fill_in 'user[password]', with: 'password'
        fill_in 'user[password_confirmation]', with: 'password'
      end

      it '正しく新規登録される' do
        expect { click_button 'Sign up' }.to change(User.all, :count).by(1)
      end
      it '新規登録後のリダイレクト先が、投稿一覧画面になっている' do
        click_button 'Sign up'
        expect(current_path).to eq '/posts'
      end
    end
  end

  describe 'ユーザログイン' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/sign_in'
      end
      it '「Sign in」と表示される' do
        expect(page).to have_content 'Sign in'
      end
      it 'emailフォームは表示される' do
        expect(page).to have_field 'user[email]'
      end
      it 'passwordフォームが表示される' do
        expect(page).to have_field 'user[password]'
      end
      it 'Sign inボタンが表示される' do
        expect(page).to have_button 'Sign in'
      end
    end

    context 'ログイン成功のテスト' do
      before do
        fill_in 'user[email]', with: user.email
        fill_in 'user[password]', with: user.password
        click_button 'Sign in'
      end

      it 'ログイン後のリダイレクト先が、投稿一覧' do
        expect(current_path).to eq '/posts'
      end
    end

    context 'ログイン失敗のテスト' do
      before do
        fill_in 'user[email]', with: ''
        fill_in 'user[password]', with: ''
        click_button 'Sign in'
      end

      it 'ログインに失敗し、ログイン画面にリダイレクトされる' do
        expect(current_path).to eq '/users/sign_in'
      end
    end
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Sign in'
    end

    context 'ヘッダーの表示を確認' do
      it 'YourLyricsリンクが表示される: 左上から1番目のリンクが「YourLyrics」である' do
        home_link = find_all('a')[0].native.inner_text
        expect(home_link).to match(//)
      end
      it 'Homeリンクが表示される: 左上から2番目のリンクが「Home」である' do
        home_link = find_all('a')[1].native.inner_text
        expect(home_link).to match(/Home/)
      end
      it 'Uploadリンクが表示される: 左上から3番目のリンクが「Upload」である' do
        books_link = find_all('a')[2].native.inner_text
        expect(books_link).to match(/Upload/)
      end
      it 'My pageリンクが表示される: 左上から4番目のリンクが「My page」である' do
        users_link = find_all('a')[3].native.inner_text
        expect(users_link).to match(/My page/)
      end
      it 'Log outリンクが表示される: 左上から5番目のリンクが「Log out」である' do
        logout_link = find_all('a')[4].native.inner_text
        expect(logout_link).to match(/Sign out/)
      end
    end
  end

  describe 'ユーザログアウトのテスト' do
    let(:user) { create(:user) }

    before do
      visit new_user_session_path
      fill_in 'user[email]', with: user.email
      fill_in 'user[password]', with: user.password
      click_button 'Sign in'
      logout_link = find_all('a')[4].native.inner_text
      logout_link = logout_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
      click_link logout_link
    end

    context 'ログアウト機能のテスト' do
      it 'ログアウト後のリダイレクト先が、トップになっている' do
        expect(current_path).to eq '/'
      end
    end
  end
end