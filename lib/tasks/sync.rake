desc 'Sync Up Transactions'
namespace :up do
  task :sync => :environment do
    Commands::SyncAccounts.run()
    Commands::SyncTransactions.run()
    Commands::SyncWebhooks.run()

    puts 'All Synced 😎'
  end
end
