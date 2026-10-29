# frozen_string_literal: true

require "minitest/autorun"
require "mbd_pay"

class TestSign < Minitest::Test
  def test_sign
    data = { app_id: "194024590982810", amount_total: 100, channel: "h5", description: "312" }
    key = "920ee68b4e16df01d0cd6b2ca161195d"
    result = MbdPay::Sign.sign(data, key)
    # 签名结果应为32位MD5
    assert_equal 32, result.length
    assert_match(/\A[0-9a-f]{32}\z/, result)
  end

  def test_sign_order_independent
    key = "test_key"
    data1 = { a: "1", b: "2", c: "3" }
    data2 = { c: "3", b: "2", a: "1" }
    assert_equal MbdPay::Sign.sign(data1, key), MbdPay::Sign.sign(data2, key)
  end
end

class TestClient < Minitest::Test
  def setup
    @client = MbdPay::Client.new("test_app_id", "test_app_key")
  end

  def test_get_openid_redirect_url
    url = @client.get_openid_redirect_url(target_url: "https://example.com/cb")
    assert url.start_with?("https://mbd.pub/openid?")
    assert url.include?("app_id=test_app_id")
    assert url.include?("target_url=https%3A%2F%2Fexample.com%2Fcb")
  end
end
