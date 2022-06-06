class AddImportLogIdToVariants < ActiveRecord::Migration[6.0]
  def change
    add_column :variants, :import_log_id, :bigint
  end
end
