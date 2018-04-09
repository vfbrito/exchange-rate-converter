# Sinatra modular app to convert USD on EUR amounts based on ECB rates
class ExchangeRateConverterApp < Sinatra::Base
  use(Rack::Conneg) do |conneg|
    conneg.set :accept_all_extensions, false
    conneg.set :fallback, :json
    conneg.provide([:json])
  end

  before do
    content_type negotiated_type if negotiated?
  end

  require_relative 'models/rate'
  require_relative 'services/exchange_rate_converter'

  get '/' do
    # Validate params
    halt 422, 'Amount is missing' if params[:amount].nil?
    begin
      date = Date.parse(params[:date])
    rescue StandardError
      halt 422, 'Date is missing'
    end
    halt 422, 'Cannot convert future date' if date > Date.today
    halt 422, 'Cannot convert dates before 1999-01-04' if date < Date.parse('1999-01-04')

    # Convert amount
    amount_eur = ExchangeRateConverter.new(
      params[:amount],
      params[:date]
    ).call
    halt 501, 'Could not proccess your request.' unless amount_eur
    [200, {
      date: params[:date],
      amount_usd: params[:amount].to_f,
      amount_eur: amount_eur
    }.to_json]
  end
end
