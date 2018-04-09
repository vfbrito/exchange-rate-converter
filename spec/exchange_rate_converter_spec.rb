require_relative 'spec_helper'

RSpec.describe ExchangeRateConverter, type: :model do
  subject { described_class.new(params[:amount], params[:date]) }

  let(:params) do
    {
      amount: 10,
      date: Date.today.to_s
    }
  end

  context 'without rates' do
    before do
      allow_any_instance_of(described_class).to receive(:find_rate)
        .with(params[:date]).and_return(nil)
    end

    it 'should respond with false' do
      expect(subject.call).to eq(false)
    end
  end

  context 'with rates' do
    before do
      allow_any_instance_of(described_class).to receive(:find_rate)
        .with(params[:date]).and_return(1)
    end

    it 'should respond with converted usd amount to eur' do
      expect(subject.call).to eq(params[:amount])
    end
  end
end
