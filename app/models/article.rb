class Article < ApplicationRecord
  # titleは100文字以内の制限をかける
  validates :title, presence: true, length: { maximum: 100 }
  validates :body, presence: true

  has_many :comments, dependent: :destroy
  has_many :article_likes, dependent: :destroy
  belongs_to :user
end
