require "rails_helper"

RSpec.describe "Api::V1::Articles", type: :request do
  describe "GET /api/v1/articles" do
    subject { get(api_v1_articles_path) }

    before do
      create_list(:article, 3)
    end

    it "記事の一覧及び記事に紐付くユーザ情報が取得できる" do
      subject
      res = JSON.parse(response.body)
      expect(res.length).to eq 3
      expect(res[0].keys).to eq ["id", "title", "body", "user"]
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET /api/v1/articles/:id" do
    subject { get(api_v1_article_path(article_id)) }

    context "指定したidの記事が存在する場合" do
      let(:article){create(:article)}
      let(:article_id){article.id}

      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(200)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["user"]["id"]).to eq article.user_id
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id){99999}
      it "記事が見つからない" do
        expect{subject}.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end
end
