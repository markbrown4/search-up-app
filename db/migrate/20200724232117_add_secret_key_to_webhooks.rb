class AddSecretKeyToWebhooks < ActiveRecord::Migration[6.0]
  def change
    add_column :webhooks, :secret_key, :string
  end
end
