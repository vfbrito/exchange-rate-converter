# Class to handle conversion rates
class ExchangeRateConverter
  attr_accessor :amount, :date, :currency

  def initialize(amount, date, currency = 'eur')
    @amount = amount
    @date = date
    @currency = currency
  end

  def call
    rate = find_rate(date)
    return false if rate.nil?
    (amount.to_f / rate.to_f).round(6)
  end

  private

  def find_rate(date)
    return nil unless Rate.exists?(currency)
    found_rate = Rate.find(key(date))
    return found_rate unless found_rate.nil?
    previous_date = (Date.parse(date) - 1).to_s
    find_rate(previous_date)
  end

  def key(d)
    "#{currency}:#{d}"
  end
end
