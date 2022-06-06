class ChangePriceType < ActiveRecord::Migration[6.0]
  def change
    change_column :products, :price, :bigint
    change_column :products, :compare_price, :bigint
  end
end
