class AddIconToIntegralRule < ActiveRecord::Migration[5.1]
  def change
    add_column :integral_rules, :icon, :string, default: '', comment: '图标的名称'
  end
end
