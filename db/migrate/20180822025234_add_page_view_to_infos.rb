class AddPageViewToInfos < ActiveRecord::Migration[5.1]
  def change
    add_column :infos, :page_views, :integer, default: 0, comment: '浏览次数'
    add_column :infos, :view_increment, :integer, default: 0, comment: '浏览量增量'
  end
end
