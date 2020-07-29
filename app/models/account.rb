# == Schema Information
#
# Table name: accounts
#
#  id               :bigint           not null, primary key
#  account_type     :string           not null
#  balance_in_cents :integer          not null
#  display_name     :string
#  created_at       :datetime         not null
#  external_id      :string           not null
#
# Indexes
#
#  index_accounts_on_external_id  (external_id) UNIQUE
#
class Account < ApplicationRecord
  include Syncable

  scope :transactional, -> { where(account_type: 'TRANSACTIONAL') }
  scope :savers, -> { where(account_type: 'SAVER') }


  def self.attributes_from_json(object)
    attributes = object.fetch('attributes')

    {
      account_type: attributes.fetch('accountType'),
      balance_in_cents: attributes.fetch('balance').fetch('valueInBaseUnits'),
      display_name: attributes.fetch('displayName', nil),
      created_at: attributes.fetch('createdAt'),
      external_id: object.fetch('id'),
    }
  end
end
