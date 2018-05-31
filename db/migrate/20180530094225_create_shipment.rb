class CreateShipment < ActiveRecord::Migration[5.1]
  def change
    create_table :shipments do |t|
      t.references :order, polymorphic: true
      t.references :express
      t.string :express_number,  comment: '快递单号'
    end
  end
end
