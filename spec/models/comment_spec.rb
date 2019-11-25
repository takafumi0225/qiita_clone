require "rails_helper"

RSpec.describe Comment, type: :model do
  describe "正常系" do
    context "内容が入力されている時" do
      let(:comment) { build(:comment) }
      it "コメントが保存できる" do
        expect(comment).to be_valid
      end
    end
  end

  describe "異常系" do
    context "本文を入力していないとき" do
      let(:comment) { build(:comment, content: nil) }
      it "記事が保存できない" do
        comment.valid?
        expect(comment.errors.messages[:content]).to include "can't be blank"
      end
    end
  end
end
