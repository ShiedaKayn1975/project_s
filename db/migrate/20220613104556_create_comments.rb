class CreateComments < ActiveRecord::Migration[6.0]
  def change
    create_table :comments do |t|
      t.bigint :creator_id
      t.string :object_type
      t.bigint :object_id
      t.text :content

      t.timestamps
    end
  end
end
