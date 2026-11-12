require "digest"

class PrivateAccess
  def self.enabled?(environment: Rails.env)
    environment.production?
  end

  def self.authorized?(username:, password:, expected_username:, expected_password:)
    return false if expected_username.blank? || expected_password.blank?

    secure_compare(username, expected_username) && secure_compare(password, expected_password)
  end

  def self.secure_compare(first, second)
    ActiveSupport::SecurityUtils.secure_compare(
      Digest::SHA256.hexdigest(first.to_s),
      Digest::SHA256.hexdigest(second.to_s)
    )
  end

  private_class_method :secure_compare
end
