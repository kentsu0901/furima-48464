require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe 'ユーザー新規登録' do
    context '登録できる場合' do
      it '必要な情報が正しく入力されていれば登録できる' do
        expect(@user).to be_valid
      end
    end

    context 'ユーザー情報に不備がある場合' do
      it 'ニックネームが空では登録できない' do
        @user.nickname = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Nickname can't be blank"
        )
      end
      it 'メールアドレスが空では登録できない' do
        @user.email = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Email can't be blank"
        )
      end
      it '同じメールアドレスでは登録できない' do
        @user.save
        another_user = FactoryBot.build(:user, email: @user.email)
        expect(another_user).to be_invalid
        expect(another_user.errors.full_messages).to include('Email has already been taken')
      end
      it 'メールアドレスは@が必須' do
        @user.email = 'abcdef'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Email is invalid'
        )
      end
      it 'パスワードが空では登録できない' do
        @user.password = ''
        @user.password_confirmation = @user.password
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Password can't be blank"
        )
      end
      it 'パスワードが6文字以上でなければ登録できない' do
        @user.password = 'abc12'
        @user.password_confirmation = @user.password
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Password is too short (minimum is 6 characters)'
        )
      end
      it 'パスワードが英字のみでは登録できない' do
        @user.password = 'abcdef'
        @user.password_confirmation = @user.password
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Password is invalid'
        )
      end
      it '全角文字を含むパスワードでは登録できない' do
        @user.password = 'abc123あ'
        @user.password_confirmation = @user.password
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Password is invalid'
        )
      end
      it 'パスワードが数字のみでは登録できない' do
        @user.password = '123456'
        @user.password_confirmation = @user.password
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Password is invalid'
        )
      end
      it 'パスワードとパスワード(確認)が一致しないと登録できない' do
        @user.password = 'abc123'
        @user.password_confirmation = 'abc124'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Password confirmation doesn't match Password"
        )
      end
    end

    context '本人情報に不備がある場合' do
      it 'お名前(全角)の苗字が空だと登録できない' do
        @user.last_name = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Last name can't be blank"
        )
      end
      it 'お名前(全角)の名前が空だと登録できない' do
        @user.first_name = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "First name can't be blank"
        )
      end
      it 'お名前(全角)の苗字が全角でなければ登録できない' do
        @user.last_name = 'Yamada'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Last name is invalid'
        )
      end
      it 'お名前(全角)の名前が全角でなければ登録できない' do
        @user.first_name = 'Taro'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'First name is invalid'
        )
      end
      it 'お名前カナ(全角)の苗字が空だと登録できない' do
        @user.last_name_kana = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Last name kana can't be blank"
        )
      end
      it 'お名前カナ(全角)の名前が空だと登録できない' do
        @user.first_name_kana = ''
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "First name kana can't be blank"
        )
      end
      it 'お名前カナ(全角)の苗字がカタカナでなければ登録できない' do
        @user.last_name_kana = '山田'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'Last name kana is invalid'
        )
      end
      it 'お名前カナ(全角)の名前がカタカナでなければ登録できない' do
        @user.first_name_kana = '太郎'
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          'First name kana is invalid'
        )
      end
      it '生年月日が空だと登録できない' do
        @user.birth_date = nil
        expect(@user).to be_invalid
        expect(
          @user.errors.full_messages
        ).to include(
          "Birth date can't be blank"
        )
      end
    end
  end
end
