class AddWebhooks < ActiveRecord::Migration[6.0]
  def change
    create_table :webhooks do |t|
      t.string :external_id, null: false, index: {unique: true}
      t.string :url, null: false
      t.datetime :created_at, null: false
    end
  end
end
