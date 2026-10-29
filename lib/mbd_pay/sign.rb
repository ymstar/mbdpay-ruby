# frozen_string_literal: true

require "digest"

module MbdPay
  # 面包多Pay签名算法实现
  # 文档: https://doc.mbd.pub/api/qian-ming-suan-fa
  module Sign
    module_function

    # 对参数进行签名
    # @param attributes [Hash] 请求参数
    # @param app_key [String] 面包多Pay app_key
    # @return [String] MD5签名字符串
    def sign(attributes, app_key)
      sorted = attributes.sort_by { |k, _v| k.to_s }
      sign_str = sorted.map { |k, v| "#{k}=#{v}" }.join("&")
      Digest::MD5.hexdigest("#{sign_str}&key=#{app_key}")
    end
  end
end
