require 'rails_helper'

RSpec.describe User, type: :model do
  describe "正常系" do
    context "ユーザ情報が条件通りに入力されている時" do
      let(:user){build(:user)}
      it "ユーザ登録できる" do
        expect(user).to be_valid
      end
    end
  end

  describe "異常系" do
    context "passwordの文字数が8字より少ないとき" do
      let(:user){build(:user, password: "12CDef")}
      it "エラーになる" do
        user.valid?
        #binding.pry
        expect(user.errors.messages[:password]).to include "Password is too short (minimum is 8 characters)"
      end
    end
    context "passwordの文字数が32字より多いとき" do
      let(:user){build(:user, password: Faker::Internet.password(min_length: 33, mix_case: true))}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "Password is too long (maximum is 32 characters)"
      end
    end
    context "passwordに数字が入っていないとき" do
      let(:user){build(:user, password: "ABCDefgh")}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end
    context "passwordにアルファベット半角大文字が入っていないとき" do
      let(:user){build(:user, password: "1234efgh")}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end
    context "passwordにアルファベット半角小文字が入っていないとき" do
      let(:user){build(:user, password: "1234EFGH")}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end

    context "タイトルを入力していないとき" do
        let(:article){build(:article,title: nil)}
        it "記事が保存できない" do
        article.valid?
        expect(article.errors.messages[:title]).to include "can't be blank"
      end
    end
    context "本文を入力していないとき" do
      let(:article){build(:article,body: nil)}
      it "記事が保存できない" do
      article.valid?
      expect(article.errors.messages[:body]).to include "can't be blank"
      end
    end
  end

  context "account を指定していないとき" do
    it "エラーする" do
      user = build(:user,account: nil)
      user.valid?

      expect(user.errors.messages[:account]).to include "can't be blank"
    end
  end

  context "同名のaccountが存在するとき" do
    it "エラーする" do
      create(:user,account: "taka")
      user = build(:user,account: "taka")
      user.valid?

      expect(user.errors.messages[:account]).to include "has already been taken"
    end
  end
end
