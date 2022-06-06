class CreateImportLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :import_logs do |t|
      t.string :status
      t.string :resource
      t.jsonb :request
      t.jsonb :response
      t.bigint :importer_id
      t.bigint :company_id

      t.timestamps
    end
    add_index :import_logs, :importer_id
    add_index :import_logs, :company_id
  end
end
