class ChangeForeignAmountToBaseUnits < ActiveRecord::Migration[6.0]
  def change
    rename_column :transactions, :foreign_amount_in_cents, :foreign_amount_in_base_units
    rename_column :transactions, :hold_foreign_amount_in_cents, :hold_foreign_amount_in_base_units
  end
end
