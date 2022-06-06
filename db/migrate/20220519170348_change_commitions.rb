class ChangeCommitions < ActiveRecord::Migration[6.0]
  def change
    remove_column :products, :commitions
    add_column :products, :commitions, :string, array: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
