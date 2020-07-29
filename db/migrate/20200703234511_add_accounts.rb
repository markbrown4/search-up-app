class AddAccounts < ActiveRecord::Migration[6.0]
  def change
    create_table :accounts do |t|
      t.string :external_id, null: false, index: {unique: true}
      t.string :display_name
      t.string :account_type, null: false
      t.integer :balance_in_cents, null: false
      t.datetime :created_at, null: false
    end
  end
end
