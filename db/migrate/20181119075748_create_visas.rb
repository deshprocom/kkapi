class CreateVisas < ActiveRecord::Migration[5.1]
  def change
    create_table :visas do |t|
      t.text :description
      t.timestamps
    end
  end
end
