require 'rack/ssl'

require 'test/unit'
require 'rack/test'

class TestSSL < Test::Unit::TestCase
  include Rack::Test::Methods

  def default_app
    Rack::SSL.new(lambda { |env|
      headers = {'Content-Type' => "text/html"}
      headers['Set-Cookie'] = "id=1; path=/\ntoken=abc; path=/; secure; HttpOnly"
      [200, headers, ["OK"]]
    })
  end

  def app
    @app ||= default_app
  end
  attr_writer :app

  def test_allows_https_url
    get "https://example.org/path?key=value"
    assert last_response.ok?
  end

  def test_allows_https_proxy_header_url
    get "http://example.org/", {}, 'HTTP_X_FORWARDED_PROTO' => "https"
    assert last_response.ok?
  end

  def test_redirects_http_to_https
    get "http://example.org/path?key=value"
    assert last_response.redirect?
    assert_equal "https://example.org/path?key=value",
      last_response.headers['Location']
  end

  def test_strict_transport_security_header
    get "https://example.org/"
    assert_equal "max-age=16070400; includeSubDomains",
      last_response.headers['Strict-Transport-Security']
  end

  def test_flag_cookies_as_secure
    get "https://example.org/"
    assert_equal ["id=1; path=/; secure", "token=abc; path=/; secure; HttpOnly"],
      last_response.headers['Set-Cookie'].split("\n")
  end
end
