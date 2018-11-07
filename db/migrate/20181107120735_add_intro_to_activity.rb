class AddIntroToActivity < ActiveRecord::Migration[5.1]
  def change
    add_column :activities, :intro, :string, default: '', comment: '活动简介'
  end
end
