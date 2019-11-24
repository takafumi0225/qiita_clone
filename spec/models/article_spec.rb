require "rails_helper"

RSpec.describe Article, type: :model do
  describe "正常系" do
    context "タイトルと本文が条件通りに入力されている時" do
      let(:article){build(:article)}
      it "記事が保存できる" do
        expect(article).to be_valid
      end
    end
  end

  describe "異常系" do
    context "タイトルの文字数が100字より多いとき" do
      let(:article){build(:article, title: Faker::Lorem.characters(number: 101))}
      it "記事が保存できない" do
        article.valid?
        expect(article.errors.messages[:title]).to include "is too long (maximum is 100 characters)"
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
end
