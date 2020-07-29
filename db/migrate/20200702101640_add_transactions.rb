class AddTransactions < ActiveRecord::Migration[6.0]
  def change
    create_table :transactions do |t|
      t.string :external_id, null: false, index: {unique: true}
      t.string :external_account_id, null: false, index: true
      t.string :status, null: false
      t.string :raw_text
      t.string :description, null: false
      t.string :message

      t.integer :hold_amount_in_cents
      t.string :hold_foreign_currency
      t.integer :hold_foreign_amount_in_cents

      t.integer :amount_in_cents, null: false
      t.string :foreign_currency
      t.integer :foreign_amount_in_cents

      t.integer :round_up_amount_in_cents
      t.integer :round_up_boost_in_cents

      t.datetime :settled_at
      t.datetime :created_at, null: false
    end
  end
end
