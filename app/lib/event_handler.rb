# Example event:
# {
#   "data": {
#     "type": "webhook-events",
#     "id": "6f6c6b3a-e4be-4bb5-b7ce-c41f289b9363",
#     "attributes": {
#       "eventType": "TRANSACTION_SETTLED",
#       "createdAt": "2020-06-24T16:48:18+10:00"
#     },
#     "relationships": {
#       "webhook": {
#         "links": {
#           "related": "https://api.up.com.au/api/v1/webhooks/3e83332e-b73b-49c9-905b-8f4d9236d003"
#         },
#         "data": {
#           "type": "webhooks",
#           "id": "3e83332e-b73b-49c9-905b-8f4d9236d003"
#         }
#       },
#       "transaction": {
#         "links": {
#           "related": "https://api.up.com.au/api/v1/transactions/8208097d-b480-4d20-8514-43b81054c865"
#         },
#         "data": {
#           "type": "transactions",
#           "id": "8208097d-b480-4d20-8514-43b81054c865"
#         }
#       }
#     }
#   }
# }

class EventHandler
  attr_reader :data
  attr_reader :client

  def self.process(data)
    new(data).process
  end

  def initialize(data)
    @data = data
    @client = Client.new
  end

  def process
    event_type = data.fetch('attributes').fetch('eventType')

    case event_type
    when 'TRANSACTION_CREATED', 'TRANSACTION_SETTLED'
      sync_transaction
    when 'TRANSACTION_DELETED'
      delete_transaction
    when 'PING'
      puts "PING from webhook received!"
    else
      raise "Unknown event: #{data.inspect}"
    end
  end

  def sync_transaction
    url = data.fetch('relationships').fetch("transaction").fetch("links").fetch("related")
    raise "Unexpected URL: #{url}" unless url.starts_with?(client.base_url)

    data = client.request(:get, url).fetch("data")
    transaction = Transaction.attributes_from_json(data)

    Transaction.sync(transaction)
    Commands::SyncAccount.run(transaction[:external_account_id])
  end

  def delete_transaction
    external_id = data.fetch('relationships').fetch("transaction").fetch("data").fetch("id")

    Transaction.find_by(external_id: external_id).destroy!
    Commands::SyncAccounts.run
  end
end
