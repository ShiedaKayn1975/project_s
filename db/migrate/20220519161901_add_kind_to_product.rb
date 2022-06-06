class AddKindToProduct < ActiveRecord::Migration[6.0]
  def change
    add_column :products, :kind, :string
  end
end
