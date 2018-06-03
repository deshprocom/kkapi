class CreateExpress < ActiveRecord::Migration[5.1]
  def change
    create_table :expresses do |t|
      t.string :name, comment: '快递公司名称'
      t.string :code, comment: '快递编码'
    end
  end
end
