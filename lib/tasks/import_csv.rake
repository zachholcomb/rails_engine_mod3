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

      CSV.foreach('./lib/merchants.csv', headers: true) do |row|
        Merchant.create(row.to_hash)
      end
      puts 'Created merchant records'

      CSV.foreach('./lib/items.csv', headers: true) do |row|
        row[3] = row[3].to_i / 100.to_f
        merchant = Merchant.find(row[4])
        merchant.items.create(row.to_hash)
      end
      puts 'Created items'

      CSV.foreach('./lib/invoices.csv', headers: true) do |row|
        if row[3] == 'shipped'
          row[3] = 0
        end
        Invoice.create(row.to_hash)
      end
      puts 'Created invoices'
  
      CSV.foreach('./lib/invoice_items.csv', headers: true) do |row|
        row[4] = row[4].to_i / 100.to_f
        ItemInvoice.create(row.to_hash)
      end
      puts 'Created invoice items'

      CSV.foreach('./lib/transactions.csv', headers: true) do |row|
        if row[3] == 'success'
          row[3] = 0
        else row[3] == 'failed'
          row[3] = 1
        end
        Transaction.create(row.to_hash)
      end
      puts 'Created transactions'

      ActiveRecord::Base.connection.tables.each do |t|
        ActiveRecord::Base.connection.reset_pk_sequence!(t)
      end
    end
  end
end
