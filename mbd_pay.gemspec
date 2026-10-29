# frozen_string_literal: true

require_relative "lib/mbd_pay/version"

Gem::Specification.new do |spec|
  spec.name = "mbd_pay"
  spec.version = MbdPay::VERSION
  spec.authors = ["yangming"]
  spec.email = ["yangming@example.com"]

  spec.summary = "面包多Pay Ruby SDK"
  spec.description = "面包多Pay (MianBaoDuo Pay) 支付集成平台的 Ruby SDK，支持微信JSAPI支付、微信H5支付、支付宝支付、退款、订单查询等功能。"
  spec.homepage = "https://doc.mbd.pub"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/yangming/mbd_pay-ruby"

  spec.files = Dir.glob("{lib,README.md,LICENSE}/**/*") + %w[README.md LICENSE]
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "minitest", "~> 5.0"
end
