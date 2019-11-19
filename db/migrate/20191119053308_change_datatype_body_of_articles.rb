class ChangeDatatypeBodyOfArticles < ActiveRecord::Migration[5.2]
  def change
     # [形式] change_column(テーブル名, カラム名, データタイプ, オプション)
     change_column :articles, :body, :text
  end
end
