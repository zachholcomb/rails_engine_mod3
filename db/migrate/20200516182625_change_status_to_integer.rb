class ChangeStatusToInteger < ActiveRecord::Migration[5.2]
  def change
    change_column :invoices, :status, 'integer USING status::integer'
  end
end
