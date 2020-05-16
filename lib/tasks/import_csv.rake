namespace :db do
  namespace :seed do
    desc 'seed database with csvs'
    task :create_files => :environment do
      Dir.glob("#{Rails.root}/app/models/*.rb").each { |file| require file }
    end
  end
end
