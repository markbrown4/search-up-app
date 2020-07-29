module ApplicationHelper
  def date(time)
    time.strftime('%b %d, %Y')
  end

  def money(amount_in_base_units, foreign_currency=nil, include_sign: true)
    parts = ''
    parts += amount_in_base_units < 0 ? '-' : '+' if include_sign
    parts += Money.new(amount_in_base_units.abs, foreign_currency).format(
      symbol: foreign_currency ? '' : '$',
      drop_trailing_zeros: true,
      with_currency: foreign_currency.present?
    )

    parts
  end

  def money_class(amount)
    "text-right #{amount > 0 ? 'credit' : 'debit'}"
  end
end
