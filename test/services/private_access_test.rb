require "test_helper"

class PrivateAccessTest < ActiveSupport::TestCase
  test "authorizes matching credentials" do
    assert PrivateAccess.authorized?(
      username: "operator",
      password: "correct-password",
      expected_username: "operator",
      expected_password: "correct-password"
    )
  end

  test "rejects non-matching credentials" do
    refute PrivateAccess.authorized?(
      username: "operator",
      password: "wrong-password",
      expected_username: "operator",
      expected_password: "correct-password"
    )
  end

  test "is enabled only in production" do
    assert PrivateAccess.enabled?(environment: ActiveSupport::StringInquirer.new("production"))
    refute PrivateAccess.enabled?(environment: ActiveSupport::StringInquirer.new("test"))
  end
end
