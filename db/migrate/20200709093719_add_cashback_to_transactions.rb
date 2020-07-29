class AddCashbackToTransactions < ActiveRecord::Migration[6.0]
  def change
    add_column :transactions, :cash_back_description, :string
    add_column :transactions, :cash_back_amount_in_cents, :integer
  end
end
