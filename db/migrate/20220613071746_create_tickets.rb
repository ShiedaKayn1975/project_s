class CreateTickets < ActiveRecord::Migration[6.0]
  def change
    create_table :tickets do |t|
      t.text :content
      t.bigint :creator_id
      t.string :status
      t.datetime :resolved_at

      t.timestamps
    end
  end
end
