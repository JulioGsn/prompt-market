class ApplicationController < ActionController::Base
  before_action :require_private_access

  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  private

  def require_private_access
    return unless PrivateAccess.enabled?

    expected_username = ENV["PROMPT_STORE_USERNAME"]
    expected_password = ENV["PROMPT_STORE_PASSWORD"]

    if expected_username.blank? || expected_password.blank?
      Rails.logger.error({ event: "private_access_unconfigured" }.to_json)
      return head :service_unavailable
    end

    authenticate_or_request_with_http_basic("Prompt Store") do |username, password|
      PrivateAccess.authorized?(
        username: username,
        password: password,
        expected_username: expected_username,
        expected_password: expected_password
      )
    end
  end
end
