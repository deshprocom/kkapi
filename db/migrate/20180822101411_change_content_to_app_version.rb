class ChangeContentToAppVersion < ActiveRecord::Migration[5.1]
  def change
    change_column(:app_versions, :content, :text, comment: '更新内容')
  end
end
