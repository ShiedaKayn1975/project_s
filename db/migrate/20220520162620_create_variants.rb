class CreateVariants < ActiveRecord::Migration[6.0]
  def change
    create_table :variants do |t|
      t.bigint :product_id
      t.string :info
      t.string :status
      t.string :account_uid
      t.bigint :owner

      t.timestamps
    end
  end
end
