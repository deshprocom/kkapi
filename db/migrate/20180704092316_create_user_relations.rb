class CreateUserRelations < ActiveRecord::Migration[5.1]
  def change
    create_table :user_relations do |t|
      t.references :user
      t.integer :pid, null: true, index: true, comment: '上级ID，直接推荐者'
      t.integer :gid, null: true, index: true, comment: '上级的上级ID，间接推荐者'
      t.integer :level, default: 1, comment: '用户级别，默认是一级用户'
      t.timestamps
    end
  end
end

