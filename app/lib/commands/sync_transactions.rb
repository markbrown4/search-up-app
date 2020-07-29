module Commands
  class SyncTransactions

    def self.run()
      print "Syncing Transactions "
      new().run()
      puts ""
    end

    def initialize
      @hold_ids_to_sync = Transaction.holds.map(&:external_id)
      @page_size = 100
      @client = Client.new
    end

    def run(next_link = nil)
      transactions, next_link = get_transactions(next_link)
      finished = process_transactions(transactions)

      if next_link.present? && !finished
        print '.'
        $stdout.flush
        run(next_link)
      end
    end

    def get_transactions(next_link)
      response = if next_link.nil?
        @client.get_transactions(page_size: @page_size)
      else
        @client.request(:get, next_link)
      end

      data = response.fetch('data')
      next_link = response.fetch('links').fetch('next', nil)

      transactions = data.map do |object|
        Transaction.attributes_from_json(object)
      end

      [transactions, next_link]
    end

    def process_transactions(transactions)
      return true if transactions.empty?

      final_page = final_page?(transactions)
      Transaction.sync_all transactions

      return true if final_page

      false
    end

    def final_page?(transactions)
      return true if transactions.count < @page_size

      @hold_ids_to_sync -= transactions.map {|t| t[:external_id]}
      holds_synced = @hold_ids_to_sync.count == 0

      last_already_synced = Transaction.exists?(external_id: transactions.last[:external_id])

      holds_synced && last_already_synced
    end
  end
end
