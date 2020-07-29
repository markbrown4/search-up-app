# == Schema Information
#
# Table name: webhooks
#
#  id          :bigint           not null, primary key
#  secret_key  :string
#  url         :string           not null
#  created_at  :datetime         not null
#  external_id :string           not null
#
# Indexes
#
#  index_webhooks_on_external_id  (external_id) UNIQUE
#
class Webhook < ApplicationRecord
  include Syncable

  def self.attributes_from_json(object)
    attributes = object.fetch('attributes')

    {
      external_id: object.fetch('id'),
      url: attributes.fetch('url'),
      created_at: attributes.fetch('createdAt'),
      secret_key: attributes.fetch('secretKey'),
    }
  end
end
