require "test_helper"

class SecurityHeadersTest < ActionDispatch::IntegrationTest
  test "sets browser security headers" do
    get root_url

    assert_response :success
    assert_equal "nosniff", response.headers["X-Content-Type-Options"]
    assert_equal "DENY", response.headers["X-Frame-Options"]
    assert_equal "strict-origin-when-cross-origin", response.headers["Referrer-Policy"]
    assert_includes response.headers["Content-Security-Policy"], "default-src 'self'"
    assert_includes response.headers["Content-Security-Policy"], "script-src 'none'"
  end
end
