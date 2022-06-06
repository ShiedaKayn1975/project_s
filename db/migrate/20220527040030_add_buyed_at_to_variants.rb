class AddBuyedAtToVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :variants, :buyed_at, :datetime
  end
end
