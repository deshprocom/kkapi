class AddDelayToExpensivePrizeCount < ActiveRecord::Migration[5.1]
  def change
    add_column :expensive_prize_counts, :delay, :boolean, default: false
  end
end
