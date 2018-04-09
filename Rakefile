namespace :eur_rates do
  desc 'Download and update EUR rates'
  task :update do
    require 'csv'
    require 'open-uri'
    require 'redis'
    require_relative 'models/rate'

    csv_url = 'http://sdw.ecb.europa.eu/quickviewexport.do?SERIES_KEY=120.EXR.D.USD.EUR.SP00.A&type=csv'

    CSV.new(open(csv_url), headers: true, skip_blanks: true).each do |row|
      begin
        date = Date.parse(row[0]).to_s
        rate = row[1].to_f
        Rate.save("eur:#{date}", rate) if rate > 0
      rescue StandardError
        false
      end
    end
  end
end
