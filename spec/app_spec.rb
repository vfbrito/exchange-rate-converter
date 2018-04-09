require_relative 'spec_helper'
require_relative '../app.rb'
require 'date'

RSpec.describe 'ExchangeRateConverterApp' do
  describe 'GET /' do
    subject { -> { get "/?#{params}" } }

    context 'with invalid params' do
      describe 'with nil amount' do
        let(:params) { '' }

        it 'should respond with status 422 unprocessable entity' do
          subject.call
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.status).to eq(422)
          expect(last_response.body).to eq('Amount is missing')
        end
      end

      describe 'with nil date' do
        let(:amount) { 10 }
        let(:params) { "amount=#{amount}" }

        it 'should respond with status 422 unprocessable entity' do
          subject.call
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.status).to eq(422)
          expect(last_response.body).to eq('Date is missing')
        end
      end

      describe 'with invalid date' do
        let(:amount) { 10 }
        let(:date) { 'invalid' }
        let(:params) { "amount=#{amount}&date=#{date}" }

        it 'should respond with status 422 unprocessable entity' do
          subject.call
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.status).to eq(422)
          expect(last_response.body).to eq('Date is missing')
        end
      end

      describe 'with future date' do
        let(:amount) { 10 }
        let(:date) { Date.today + 1 }
        let(:params) { "amount=#{amount}&date=#{date}" }

        it 'should respond with status 422 unprocessable entity' do
          subject.call
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.status).to eq(422)
          expect(last_response.body).to eq('Cannot convert future date')
        end
      end

      describe 'with date before 1999-01-04' do
        let(:amount) { 10 }
        let(:date) { '1999-01-03' }
        let(:params) { "amount=#{amount}&date=#{date}" }

        it 'should respond with status 422 unprocessable entity' do
          subject.call
          expect(last_response.content_type).to eq('application/json')
          expect(last_response.status).to eq(422)
          expect(last_response.body)
            .to eq('Cannot convert dates before 1999-01-04')
        end
      end
    end

    context 'with valid params' do
      let(:amount) { 10 }
      let(:date) { Date.today }
      let(:params) { "amount=#{amount}&date=#{date}" }
      let(:expected_response) do
        {
          date: date,
          amount_usd: amount.to_f,
          amount_eur: amount.to_f
        }
      end

      before do
        allow_any_instance_of(ExchangeRateConverter).to receive(:call)
          .and_return(expected_response[:amount_eur])
      end

      it 'should respond with status 200 ok' do
        subject.call
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.status).to eq(200)
      end

      it 'should respond with converted usd amount to eur' do
        subject.call
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.body).to eq(expected_response.to_json)
      end
    end

    context 'with valid params without rates' do
      let(:amount) { 10 }
      let(:date) { Date.today }
      let(:params) { "amount=#{amount}&date=#{date}" }

      before do
        allow_any_instance_of(ExchangeRateConverter).to receive(:call)
          .and_return(false)
      end

      it 'should respond with status 501 not implemented' do
        subject.call
        expect(last_response.content_type).to eq('application/json')
        expect(last_response.status).to eq(501)
        expect(last_response.body)
          .to eq('Could not proccess your request.')
      end
    end
  end
end
