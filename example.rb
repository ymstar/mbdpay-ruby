#!/usr/bin/env ruby
# frozen_string_literal: true

# 面包多Pay Ruby SDK 使用示例
# 运行前请替换为你自己的 app_id 和 app_key
# 获取地址: https://mbd.pub/dev

require_relative "lib/mbd_pay"

APP_ID = "your_app_id"
APP_KEY = "your_app_key"

client = MbdPay::Client.new(APP_ID, APP_KEY)

# === 1. 获取用户 openid 跳转链接 ===
puts "=== 获取 openid 跳转链接 ==="
url = client.get_openid_redirect_url(
  target_url: "https://your-site.com/openid_callback"
)
puts "跳转URL: #{url}"
puts

# === 2. 微信 JSAPI 支付 ===
puts "=== 微信 JSAPI 支付 ==="
begin
  result = client.wx_jsapi(
    openid: "用户openid",
    description: "测试商品",
    amount_total: 100,  # 1元 = 100分
    callback_url: "https://your-site.com/pay/callback",
    out_trade_no: "ORDER_001"
  )
  puts "JSAPI参数: #{result}"
rescue MbdPay::Error => e
  puts "错误: #{e.message}"
end
puts

# === 3. 微信 H5 支付 ===
puts "=== 微信 H5 支付 ==="
begin
  result = client.wx_h5(
    description: "测试商品",
    amount_total: 100,
    out_trade_no: "ORDER_002"
  )
  puts "H5支付链接: #{result['h5_url']}"
rescue MbdPay::Error => e
  puts "错误: #{e.message}"
end
puts

# === 4. 支付宝支付 ===
puts "=== 支付宝支付 ==="
begin
  result = client.alipay(
    url: "https://your-site.com/pay/callback",
    description: "测试商品",
    amount_total: 100,
    out_trade_no: "ORDER_003"
  )
  puts "支付宝表单HTML: #{result['body'][0..100]}..."
rescue MbdPay::Error => e
  puts "错误: #{e.message}"
end
puts

# === 5. 查询订单 ===
puts "=== 查询订单 ==="
begin
  result = client.search_order(out_trade_no: "ORDER_001")
  puts "订单信息: #{result}"
rescue MbdPay::Error => e
  puts "错误: #{e.message}"
end
puts

# === 6. 退款 ===
puts "=== 退款 ==="
begin
  result = client.refund(order_id: "面包多订单号")
  puts "退款结果: #{result}"
rescue MbdPay::Error => e
  puts "错误: #{e.message}"
end
