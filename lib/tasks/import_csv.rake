namespace :db do
  namespace :seed do
    desc 'seed database with csvs'
    task :from_csv => :environment do
      require 'csv'
      Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }

      system 'rails db:reset'
      
      CSV.foreach('./lib/customers.csv', headers: true) do |row|
        Customer.create(row.to_hash)
      end
      puts 'Created customer records'
    end
  end
end
