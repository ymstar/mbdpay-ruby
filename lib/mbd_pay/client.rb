# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module MbdPay
  # 面包多Pay客户端
  #
  # @example 创建客户端
  #   client = MbdPay::Client.new("your_app_id", "your_app_key")
  class Client
    DEFAULT_DOMAIN = "https://api.mianbaoduo.com"
    DEFAULT_TIMEOUT = 15

    attr_reader :app_id, :app_key, :domain

    # @param app_id [String] 面包多Pay app_id
    # @param app_key [String] 面包多Pay app_key
    # @param domain [String] API域名
    # @param timeout [Integer] 请求超时时间（秒）
    def initialize(app_id, app_key, domain: DEFAULT_DOMAIN, timeout: DEFAULT_TIMEOUT)
      @app_id = app_id
      @app_key = app_key
      @domain = domain
      @timeout = timeout
    end

    # 获取用户openid的跳转URL
    # 文档: https://doc.mbd.pub/api/huo-qu-yong-hu-openid
    #
    # @param target_url [String] 回调URL
    # @return [String] 跳转URL
    def get_openid_redirect_url(target_url:)
      base_url = "https://mbd.pub/openid"
      params = { app_id: app_id, target_url: target_url }
      uri = URI(base_url)
      uri.query = URI.encode_www_form(params)
      uri.to_s
    end

    # 微信JSAPI支付
    # 文档: https://doc.mbd.pub/api/wei-xin-zhi-fu
    #
    # @param openid [String] 用户openid
    # @param description [String] 商品描述
    # @param amount_total [Integer] 订单金额（单位：分）
    # @param callback_url [String] 支付完成后跳转的URL
    # @param out_trade_no [String, nil] 外部系统订单号
    # @return [Hash] JSAPI支付参数
    def wx_jsapi(openid:, description:, amount_total:, callback_url:, out_trade_no: nil)
      params = {
        openid: openid,
        description: description,
        amount_total: amount_total,
        callback_url: callback_url
      }
      params[:out_trade_no] = out_trade_no if out_trade_no

      post("/release/wx/prepay", params)
    end

    # 微信H5支付
    # 文档: https://doc.mbd.pub/api/wei-xin-h5-zhi-fu
    #
    # @param description [String] 商品描述
    # @param amount_total [Integer] 订单金额（单位：分）
    # @param out_trade_no [String, nil] 外部系统订单号
    # @return [Hash] 包含h5_url的响应
    def wx_h5(description:, amount_total:, out_trade_no: nil)
      params = {
        channel: "h5",
        description: description,
        amount_total: amount_total
      }
      params[:out_trade_no] = out_trade_no if out_trade_no

      post("/release/wx/prepay", params)
    end

    # 支付宝支付
    # 文档: https://doc.mbd.pub/api/zhi-fu-bao-zhi-fu
    #
    # @param url [String] 支付后跳转URL
    # @param description [String] 商品描述
    # @param amount_total [Integer] 订单金额（单位：分）
    # @param out_trade_no [String, nil] 外部系统订单号
    # @param callback_url [String, nil] 回调URL
    # @return [Hash] 包含body(HTML表单)的响应
    def alipay(url:, description:, amount_total:, out_trade_no: nil, callback_url: nil)
      params = {
        url: url,
        description: description,
        amount_total: amount_total
      }
      params[:out_trade_no] = out_trade_no if out_trade_no
      params[:callback_url] = callback_url if callback_url

      post("/release/alipay/pay", params)
    end

    # 退款
    # 文档: https://doc.mbd.pub/api/tui-kuan
    #
    # @param order_id [String] 订单号
    # @return [Hash] 退款结果
    def refund(order_id:)
      post("/release/main/refund", { order_id: order_id })
    end

    # 查询订单
    # 文档: https://doc.mbd.pub/api/ding-dan-cha-xun
    #
    # @param out_trade_no [String] 外部系统订单号
    # @return [Hash] 订单信息
    def search_order(out_trade_no:)
      post("/release/main/search_order", { out_trade_no: out_trade_no })
    end

    private

    # 构建请求参数并签名
    def build_request(params)
      params = params.merge(app_id: app_id)
      params = params.reject { |_, v| v.nil? }
      sign = Sign.sign(params, app_key)
      params.merge(sign: sign)
    end

    # 发送POST请求
    def post(path, params)
      body = build_request(params)
      uri = URI("#{domain}#{path}")

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = (uri.scheme == "https")
      http.open_timeout = @timeout
      http.read_timeout = @timeout

      request = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
      request.body = JSON.generate(body)

      response = http.request(request)
      result = JSON.parse(response.body)

      if result.is_a?(Hash) && result["error"]
        raise Error, result["error"]
      end

      result
    end
  end
end
