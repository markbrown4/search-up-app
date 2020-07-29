# == Schema Information
#
# Table name: transactions
#
#  id                                :bigint           not null, primary key
#  amount_in_cents                   :integer          not null
#  cash_back_amount_in_cents         :integer
#  cash_back_description             :string
#  description                       :string           not null
#  foreign_amount_in_base_units      :integer
#  foreign_currency                  :string
#  hold_amount_in_cents              :integer
#  hold_foreign_amount_in_base_units :integer
#  hold_foreign_currency             :string
#  message                           :string
#  raw_text                          :string
#  round_up_amount_in_cents          :integer
#  round_up_boost_in_cents           :integer
#  settled_at                        :datetime
#  status                            :string           not null
#  created_at                        :datetime         not null
#  external_account_id               :string           not null
#  external_id                       :string           not null
#
# Indexes
#
#  index_transactions_on_external_account_id  (external_account_id)
#  index_transactions_on_external_id          (external_id) UNIQUE
#
class Transaction < ApplicationRecord
  include Syncable

  scope :holds, -> { where(status: 'HELD') }

  def self.attributes_from_json(object)
    attributes = object.fetch('attributes')
    account = object.fetch('relationships').fetch('account').fetch('data')
    hold = attributes.fetch('holdInfo', nil)
    hold_amount = hold&.fetch('amount')
    hold_foreign_amount = hold&.fetch('foreignAmount')
    round_up = attributes.fetch('roundUp', nil)
    round_up_amount = round_up&.fetch('amount')
    round_up_boost = round_up&.fetch('boostPortion')
    amount = attributes.fetch('amount')
    foreign_amount = attributes.fetch('foreignAmount', nil)
    cash_back = round_up = attributes.fetch('cashback', nil)
    cash_back_amount = cash_back&.fetch('amount')

    {
      external_id: object.fetch('id'),
      external_account_id: account.fetch('id'),
      status: attributes.fetch('status'),
      raw_text: attributes.fetch('rawText', nil),
      description: attributes.fetch('description'),
      message: attributes.fetch('message', nil),
      hold_amount_in_cents: hold_amount&.fetch('valueInBaseUnits'),
      hold_foreign_currency: hold_foreign_amount&.fetch('currencyCode'),
      hold_foreign_amount_in_base_units: hold_foreign_amount&.fetch('valueInBaseUnits'),
      amount_in_cents: amount.fetch('valueInBaseUnits'),
      foreign_currency: foreign_amount&.fetch('currencyCode'),
      foreign_amount_in_base_units: foreign_amount&.fetch('valueInBaseUnits'),
      round_up_amount_in_cents: round_up_amount&.fetch('valueInBaseUnits'),
      round_up_boost_in_cents: round_up_boost&.fetch('valueInBaseUnits'),
      cash_back_description: cash_back&.fetch('description'),
      cash_back_amount_in_cents: cash_back_amount&.fetch('valueInBaseUnits'),
      settled_at: attributes.fetch('settledAt', nil),
      created_at: attributes.fetch('createdAt')
    }
  end

  def self.search(query)
    where('description ILIKE ?', "%#{query}%")
  end

  def total_amount_in_cents
    amount_in_cents +
      (round_up_amount_in_cents || 0) +
      (cash_back_amount_in_cents || 0)
  end

  def hold?
    status == 'HELD'
  end

  def round_up?
    round_up_amount_in_cents.present? || round_up_boost_in_cents.present?
  end

  def formatted_description
    parts = description
    parts += " - #{message}" if message.present?

    parts
  end
end
