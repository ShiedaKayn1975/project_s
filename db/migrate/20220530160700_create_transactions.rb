class CreateTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.bigint :user_id
      t.string :method
      t.string :message
      t.bigint :amount
      t.string :reference

      t.timestamps
    end
    add_index :transactions, :user_id
  end
end
