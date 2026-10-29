# 面包多Pay Ruby SDK

面向个人的支付集成平台 [面包多Pay](https://mbd.pub) 的 Ruby SDK。

## 安装

### Gem 安装

```bash
gem install mbd_pay
```

### Gemfile 添加

```ruby
gem 'mbd_pay'
```

### 手动安装

```bash
git clone https://github.com/yangming/mbd_pay-ruby.git
cd mbd_pay-ruby
bundle install
```

## 使用

### 初始化

```ruby
require 'mbd_pay'

client = MbdPay::Client.new(
  'your_app_id',       # 面包多Pay app_id
  'your_app_key'       # 面包多Pay app_key
)
```

### 微信 JSAPI 支付

```ruby
result = client.wx_jsapi(
  openid: '用户openid',
  description: '商品描述',
  amount_total: 100,          # 金额，单位：分
  callback_url: 'https://your-site.com/callback',
  out_trade_no: '订单号'       # 可选
)
# => { "appId" => "...", "timeStamp" => "...", "nonceStr" => "...", "package" => "...", "signType" => "...", "paySign" => "..." }
```

### 微信 H5 支付

```ruby
result = client.wx_h5(
  description: '商品描述',
  amount_total: 100,          # 金额，单位：分
  out_trade_no: '订单号'       # 可选
)
# => { "h5_url" => "https://wx.tenpay.com/..." }
```

### 支付宝支付

```ruby
result = client.alipay(
  url: 'https://your-site.com/pay/callback',
  description: '商品描述',
  amount_total: 100,          # 金额，单位：分
  out_trade_no: '订单号'       # 可选
)
# => { "body" => "<form id='alipaysubmit' ...>...</form>" }
```

### 退款

```ruby
result = client.refund(order_id: '面包多订单号')
# => { "code" => 200, "info" => "...", "message" => "..." }
```

### 查询订单

```ruby
result = client.search_order(out_trade_no: '你的订单号')
# => { "order_id" => "...", "state" => 1, "amount" => 100, ... }
```

### 获取用户 OpenID 跳转链接

```ruby
url = client.get_openid_redirect_url(target_url: 'https://your-site.com/openid_callback')
# 重定向用户到此 URL 以获取 openid
```

## 签名算法

参数按 key 排序后拼接为 `key1=value1&key2=value2`，末尾追加 `&key=APP_KEY`，取 MD5。

文档：https://doc.mbd.pub/api/qian-ming-suan-fa

## License

MIT
