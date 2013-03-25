namespace :shop_on_rails do
  desc 'Fresh setup with the Spree samples'
  task :setup_with_samples => :environment do
    `rm -rf #{Rails.root}/public/spree`
    `cd #{Rails.root} && bundle exec rake shop_on_rails:setup`
    `cd #{Rails.root} && bundle exec rake spree_sample:load`
  end

  desc 'Refresh db without the Spree samples'
  task :refresh_db => :environment do
    ActiveRecord::Base.connection.tables.each do |x|
      ActiveRecord::Base.connection.drop_table x
    end

    Rake::Task['db:migrate'].invoke
    Rake::Task['db:seed'].invoke
    SpreefineryCore::Engine.load_seed
  end

  desc 'Refresh db with the Spree samples'
  task :refresh_db_with_samples => :environment do
    `rm -rf #{Rails.root}/public/spree`
    `cd #{Rails.root} && bundle exec rake spree_sample:load`
  end


  desc 'Setup The ShopOnRails'
  task :setup => :environment do
    `cd #{Rails.root} &&  mkdir themes`
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git default`
    `cd #{Rails.root}/themes && git clone git://github.com/shoponrails/spreefinery_default_theme.git sprockets`
    `cd #{Rails.root}/themes/sprockets && git checkout -b sprockets origin/sprockets`

    `cd #{Rails.root} && bundle exec rails g spree:install --migrate=false --sample=false --seed=false --user_class=Refinery::User`
    `cd #{Rails.root} && bundle exec rails g refinery:cms --fresh-installation`
    `cd #{Rails.root} && bundle exec rails g refinery:i18n`
    `cd #{Rails.root} && bundle exec rails g refinery:pages`
    `cd #{Rails.root} && bundle exec rails g refinery:inquiries`
    `cd #{Rails.root} && bundle exec rails g refinery:blog`
    `cd #{Rails.root} && bundle exec rails g refinery:news`
    `cd #{Rails.root} && bundle exec rake spreefinery_core:install:migrations`
    `cd #{Rails.root} && bundle exec rake shop_on_rails:refresh_db`
  end
end