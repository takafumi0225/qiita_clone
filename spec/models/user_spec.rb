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
      let(:user){build(:user, password: "12CDef7")}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "is invalid"
      end
    end
    context "passwordの文字数が32字より多いとき" do
      let(:user){build(:user, password: Faker::Internet.password(min_length: 33, mix_case: true))}
      it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:password]).to include "is invalid"
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
    context "passwordが入力されていないとき" do
      let(:user){build(:user, password: nil)}
      it "登録できない" do
        user.valid?
        expect(user.errors.messages[:password]).to include "can't be blank"
      end
    end

    context "emailに@を入力していないとき" do
      let(:user){build(:user,email: "1234asdf.co.jp")}
        it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:email]).to include "is invalid"
      end
    end
    context "emailに.を入力していないとき" do
      let(:user){build(:user,email: "1234abcdf@cojp")}
        it "エラーになる" do
        user.valid?
        expect(user.errors.messages[:email]).to include "is invalid"
      end
    end
    context "同一のemailが既に存在するとき" do
      before {create(:user,email: "1234abcdf@co.jp")}
      let(:user){build(:user,email: "1234abcdf@co.jp")}
        it "登録できない" do
        user.valid?
        expect(user.errors.messages[:email]).to include "has already been taken"
      end
    end
    context "emailが入力されていないとき" do
      let(:user){build(:user, email: nil)}
      it "登録できない" do
        user.valid?
        expect(user.errors.messages[:email]).to include "can't be blank"
      end
    end

    context "nameが入力されていないとき" do
      let(:user){build(:user, name: nil)}
      it "登録できない" do
        user.valid?
        expect(user.errors.messages[:name]).to include "can't be blank"
      end
    end

    context "同一のaccountが既に存在するとき" do
      before {create(:user,account: "taka")}
      let(:user){build(:user,account: "taka")}
        it "登録できない" do
        user.valid?
        expect(user.errors.messages[:account]).to include "has already been taken"
      end
    end
    context "accountが入力されていないとき" do
      let(:user){build(:user, account: nil)}
      it "登録できない" do
        user.valid?
        expect(user.errors.messages[:account]).to include "can't be blank"
      end
    end
  end
end
