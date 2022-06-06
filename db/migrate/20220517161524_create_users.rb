class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :phone
      t.string :password_digest
      t.string :status
      t.boolean :admin

      t.timestamps
    end
  end
end
