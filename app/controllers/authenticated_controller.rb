class AuthenticatedController < ApplicationController
  before_action :authenticate

  def authenticate
    return unless Rails.env.production?
    http_basic_authenticate_or_request_with name: ENV['UP_NAME'], password: ENV['UP_ACCESS_TOKEN']
  end
end
