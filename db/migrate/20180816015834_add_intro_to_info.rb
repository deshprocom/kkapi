class AddIntroToInfo < ActiveRecord::Migration[5.1]
  def change
    add_column :infos, :intro, :string, comment: '简介'
  end
end
