class CreateDynamics < ActiveRecord::Migration[5.1]
  def change
    create_table :dynamics do |t|
      t.references :user
      t.string :option_type, comment: '操作类型'
      t.string :target_type
      t.integer :target_id
      t.timestamps
    end
    add_index :dynamics, [:option_type]
    add_index :dynamics, [:target_type, :target_id]
  end
end
