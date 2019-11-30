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
      let(:article) { create(:article) }
      let(:article_id) { article.id }

      it "記事の値が取得できる" do
        subject
        res = JSON.parse(response.body)
        expect(response).to have_http_status(:ok)
        expect(res["id"]).to eq article.id
        expect(res["title"]).to eq article.title
        expect(res["body"]).to eq article.body
        expect(res["user"]["id"]).to eq article.user_id
      end
    end

    context "指定したidの記事が存在しない場合" do
      let(:article_id) { 99999 }
      it "記事が見つからない" do
        expect { subject }.to raise_error ActiveRecord::RecordNotFound
      end
    end
  end

  describe "POST /api/v1/articles" do
    subject { post(api_v1_articles_path, params: params) }

    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    before do
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
    end

    it "記事が作成できる" do
      expect { subject }.to change { current_user.articles.count }.by(1)
      res = JSON.parse(response.body)
      expect(response).to have_http_status(:ok)
      expect(res["title"]).to eq params[:article][:title]
      expect(res["body"]).to eq params[:article][:body]
    end
  end

  describe "PATCH /api/v1/articles/:id" do
    subject { patch(api_v1_article_path(article.id), params: params) }
    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }

    before do
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
    end

    context "その記事がログインしているユーザの記事の場合" do
      let(:article){create(:article, user:current_user)}

      it "任意の記事のレコードを更新できる" do
        expect { subject }.to change { Article.find(article.id).title }.from(article.title).to(params[:article][:title])&
        change { Article.find(article.id).body }.from(article.body).to(params[:article][:body])
      end
    end

    context "その記事がログインしているユーザ以外の記事の場合" do
      let(:other_user){create(:user)}
      let(:article){create(:article, user:other_user)}

      it "エラーになる" do
        expect { subject }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end

  describe "DELETE /api/v1/articles/:id" do
    subject { delete(api_v1_article_path(article.id), params: params) }
    let(:params) { { article: attributes_for(:article) } }
    let(:current_user) { create(:user) }
    let!(:article){ create(:article) }

    before do
      allow_any_instance_of(Api::V1::BaseApiController).to receive(:current_user).and_return(current_user)
    end

    it "任意の記事のレコードを削除できる" do
      #expect { subject }.to change { current_user.articles.count }.by(-1)
      #expect(response).to have_http_status(204)
    end
  end
end
