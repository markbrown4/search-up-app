require 'rest-client'

class Client
  attr_reader :base_url

  def initialize(base_url: 'https://api.up.com.au/api/v1/', token: ENV['UP_ACCESS_TOKEN'])
    @base_url = base_url
    @token = token
  end

  def inspect
    "#<Client::#{object_id} @base_url=#{base_url}>"
  end

  def request(method, url, params = nil)
    headers = {
      Authorization: "Bearer #{@token}",
      'Content-Type': 'application/json',
    }
    headers[:params] = params if method == :get && params.present?
    payload = method == :get ? nil : params

    response = RestClient::Request.execute(
      method: method,
      url: url,
      payload: payload&.to_json,
      headers: headers
    )

    JSON.parse(response.body) if response.body.present?
  rescue => e
    puts e.message
  end

  def get(path, params = nil)
    request(:get, "#{@base_url}#{path}", params)
  end

  def post(path, payload = nil)
    request(:post, "#{@base_url}#{path}", payload)
  end

  def delete(path)
    request(:delete, "#{@base_url}#{path}")
  end

  def get_transactions(page_size: 100, before: nil, after: nil)
    params = {'page[size]' => page_size}
    params['filter[until]'] = before.iso8601 if before.present?
    params['filter[since]'] = after.iso8601 if after.present?

    get('transactions', params)
  end

  def get_transaction(id)
    get("transactions/#{id}")
  end

  def get_accounts(page_size: 100)
    get('accounts', { 'page[size]' => page_size })
  end

  def get_account(id)
    get("accounts/#{id}")
  end

  def get_webhooks(page_size: 100)
    get("webhooks", { 'page[size]' => page_size })
  end

  def get_webhook(id)
    get("webhooks/#{id}")
  end

  def create_webhook(url:)
    post("webhooks", {
      data: {
        attributes: {
          url: url
        }
      }
    })
  end

  def delete_webhook(id)
    delete("webhooks/#{id}")
  end

  def ping_webhook(id)
    post("webhooks/#{id}/ping")
  end
end
