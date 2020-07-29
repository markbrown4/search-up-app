class InboundController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :validate_signature

  def event
    EventHandler.process(data)
    head :ok
  end

  private

  def data
    JSON.parse(request.body.read).fetch('data')
  end

  def validate_signature
    received_signature = request.headers['X-Up-Authenticity-Signature']
    signature = OpenSSL::HMAC.hexdigest(
      'SHA256',
      webhook.secret_key,
      request.raw_post,
    )
    unless Rack::Utils.secure_compare(received_signature, signature)
      raise "Invalid webhook: #{request.raw_post}"
    end
  end

  def webhook
    external_id = data.fetch('relationships').fetch("webhook").fetch("data").fetch("id")

    Webhook.find_by(external_id: external_id) || raise("Unkown webhook: #{data.inspect}")
  end
end
