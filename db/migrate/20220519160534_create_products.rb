class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.string :title
      t.float :price
      t.float :compare_price
      t.string :commitions
      t.bigint :creator_id
      t.boolean :active
      t.integer :index

      t.timestamps
    end
  end
end
