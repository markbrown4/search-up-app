module Commands
  class RemoveWebhook
    def self.run(url:)
      puts "Removing Webhook"

      webhook = Webhook.find_by(url: url)
      Client.new.delete_webhook(webhook.external_id)
      webhook.destroy!
    end
  end
end
