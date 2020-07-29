module Commands
  class SyncWebhooks
    def self.run()
      puts "Syncing Webhooks"

      data = Client.new.get_webhooks().fetch('data')
      return if data.empty?

      webhooks = data.map do |object|
        Webhook.attributes_from_json(object)
      end

      Webhook.sync_all webhooks
    end
  end
end
