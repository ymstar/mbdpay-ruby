# frozen_string_literal: true

require_relative "mbd_pay/version"
require_relative "mbd_pay/sign"
require_relative "mbd_pay/client"

module MbdPay
  class Error < StandardError; end
end
