class AddCodeToTickets < ActiveRecord::Migration[6.0]
  def change
    add_column :tickets, :code, :string
  end
end
