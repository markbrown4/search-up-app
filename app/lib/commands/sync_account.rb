module Commands
  class SyncAccount
    def self.run(id)
      puts "Syncing Account: #{id}"

      data = Client.new.get_account(id).fetch('data')
      account = Account.attributes_from_json(data)

      Account.sync account
    end
  end
end
