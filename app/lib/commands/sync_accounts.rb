module Commands
  class SyncAccounts
    def self.run()
      puts "Syncing Accounts"

      data = Client.new.get_accounts().fetch('data')
      accounts = data.map do |object|
        Account.attributes_from_json(object)
      end

      Account.sync_all accounts
    end
  end
end
