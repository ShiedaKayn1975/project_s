class CreateActionLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :action_logs do |t|
      t.string :state
      t.string :action_code
      t.string :action_label
      t.jsonb :action_data
      t.jsonb :context
      t.bigint :actor_id
      t.string :actionable_type
      t.bigint :actionable_id
      t.jsonb :object_before
      t.jsonb :object_after
      t.jsonb :error

      t.timestamps
    end
    add_index :action_logs, :actor_id
    add_index :action_logs, :actionable_type
  end
end
