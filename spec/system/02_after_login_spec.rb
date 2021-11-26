require 'rails_helper'

describe '[STEP2] ユーザログイン後のテスト' do
  let(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:post) { create(:post, user: user) }
  let!(:other_post) { create(:post, user: other_user) }

  before do
    visit new_user_session_path
    fill_in 'user[email]', with: user.email
    fill_in 'user[password]', with: user.password
    click_button 'Sign in'
  end

  describe 'ヘッダーのテスト: ログインしている場合' do
    context 'リンクの内容を確認: ※Sign outは『ユーザログアウトのテスト』でテスト済み。' do
      subject { current_path }

      it 'Homeを押すと、投稿一覧画面に遷移する' do
        home_link = find_all('a')[1].native.inner_text
        home_link = home_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link home_link
        is_expected.to eq '/posts'
      end
      it 'Uploadを押すと、新規投稿画面に遷移する' do
        users_link = find_all('a')[2].native.inner_text
        users_link = users_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link users_link
        is_expected.to eq '/posts/new'
      end
      it 'My pageを押すと、ユーザー詳細画面に遷移する' do
        books_link = find_all('a')[3].native.inner_text
        books_link = books_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link books_link
        is_expected.to eq '/users/' + user.id.to_s
      end
      it 'Sign outを押すと、トップページに遷移する' do
        posts_link = find_all('a')[4].native.inner_text
        posts_link = posts_link.gsub(/\n/, '').gsub(/\A\s*/, '').gsub(/\s*\Z/, '')
        click_link posts_link
        is_expected.to eq '/'
      end
    end
  end

  describe '投稿一覧画面のテスト' do
    before do
      visit posts_path
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts'
      end
      it '自分と他人の画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(post.user)
        expect(page).to have_link '', href: user_path(other_post.user)
      end
      it '自分の投稿と他人の投稿の歌詞が表示される' do
        expect(page).to have_content post.body
        expect(page).to have_content other_post.body
      end
    end
  end

  describe '自分の投稿詳細画面のテスト' do
    before do
      visit post_path(post)
    end

    context '表示内容の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
      it 'ユーザ画像・名前のリンク先が正しい' do
        expect(page).to have_link post.user.name, href: user_path(post.user)
      end
      it '投稿のtitleが表示される' do
        expect(page).to have_content post.title
      end
      it '投稿の歌詞が表示される' do
        expect(page).to have_content post.body
      end
      it '投稿の編集リンクが表示される' do
        expect(page).to have_link '投稿を編集する', href: edit_post_path(post)
      end
      it '投稿の削除リンクが表示される' do
        expect(page).to have_link '投稿を削除する', href: post_path(post)
      end
    end

    context '編集リンクのテスト' do
      it '編集画面に遷移する' do
        click_link '投稿を編集する'
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
    end

    context '削除リンクのテスト' do
      before do
        click_link '投稿を削除する'
      end
      it '正しく削除される' do
        expect(Post.where(id: post.id).count).to eq 0
      end
      it 'リダイレクト先が、投稿一覧画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end

  describe '自分の投稿画面のテスト' do
    before do
      visit new_post_path
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/new'
      end
      it 'タイトルフォームが表示される' do
        expect(page).to have_field 'post[title]'
      end
      it '歌詞フォームが表示される' do
        expect(page).to have_field 'post[body]'
      end
      it 'Uploadボタンが表示される' do
        expect(page).to have_button 'Upload'
      end
      it 'Cancelリンクが表示される' do
        expect(page).to have_link 'Cancel', href: posts_path
      end
    end

    context '投稿成功のテスト' do
      before do
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 5)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 20)
      end
      it '自分の新しい投稿が正しく保存される' do
        expect { click_button 'Upload' }.to change(user.posts, :count).by(1)
      end
      it 'リダイレクト先が、保存できた投稿の詳細画面になっている' do
        click_button 'Upload'
        expect(current_path).to eq '/posts/' + Post.last.id.to_s
      end
    end
  end

  describe '自分の投稿編集画面のテスト' do
    before do
      visit edit_post_path(post)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/posts/' + post.id.to_s + '/edit'
      end
      it 'title編集フォームが表示される' do
        expect(page).to have_field 'post[title]', with: post.title
      end
      it 'opinion編集フォームが表示される' do
        expect(page).to have_field 'post[body]', with: post.body
      end
      it 'Save changesボタンが表示される' do
        expect(page).to have_button 'Save changes'
      end
      it 'Cancelリンクが表示される' do
        expect(page).to have_link 'Cancel', href: post_path(post)
      end
    end

    context '編集成功のテスト' do
      before do
        @post_old_title = post.title
        @post_old_body = post.body
        fill_in 'post[title]', with: Faker::Lorem.characters(number: 4)
        fill_in 'post[body]', with: Faker::Lorem.characters(number: 19)
        click_button 'Save changes'
      end

      it 'titleが正しく更新される' do
        expect(post.reload.title).not_to eq @post_old_title
      end
      it 'bodyが正しく更新される' do
        expect(post.reload.body).not_to eq @post_old_body
      end
      it 'リダイレクト先が、更新した投稿の詳細画面になっている' do
        expect(current_path).to eq '/posts/' + post.id.to_s
      end
    end
  end

  describe '自分のユーザ詳細画面のテスト' do
    before do
      visit user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
      it '投稿一覧のユーザ画像のリンク先が正しい' do
        expect(page).to have_link '', href: user_path(user)
      end
      it '他人の投稿は表示されない' do
        expect(page).not_to have_link '', href: user_path(other_user)
        expect(page).not_to have_content other_post.title
        expect(page).not_to have_content other_post.body
      end
    end
  end

  describe '自分のユーザ情報編集画面のテスト' do
    before do
      visit edit_user_path(user)
    end

    context '表示の確認' do
      it 'URLが正しい' do
        expect(current_path).to eq '/users/' + user.id.to_s + '/edit'
      end
      it '名前編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: user.name
      end
      it '画像編集フォームが表示される' do
        expect(page).to have_field 'user[image]'
      end
      it '自己紹介編集フォームに自分の自己紹介文が表示される' do
        expect(page).to have_field 'user[caption]', with: user.caption
      end
      it 'Save changesボタンが表示される' do
        expect(page).to have_button 'Save changes'
      end
    end

    context '更新成功のテスト' do
      before do
        @user_old_name = user.name
        @user_old_intrpduction = user.caption
        fill_in 'user[name]', with: Faker::Lorem.characters(number: 9)
        fill_in 'user[caption]', with: Faker::Lorem.characters(number: 19)
        click_button 'Save changes'
      end

      it 'nameが正しく更新される' do
        expect(user.reload.name).not_to eq @user_old_name
      end
      it 'captionが正しく更新される' do
        expect(user.reload.caption).not_to eq @user_old_caption
      end
      it 'リダイレクト先が、自分のユーザ詳細画面になっている' do
        expect(current_path).to eq '/users/' + user.id.to_s
      end
    end
  end
end
