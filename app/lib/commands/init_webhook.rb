module Commands
  class InitWebhook
    def self.run(url:)
      puts "Creating Webhook"

      data = Client.new.create_webhook(url: url).fetch('data')
      webhook = Webhook.attributes_from_json(data)

      Webhook.sync webhook
    end
  end
end
