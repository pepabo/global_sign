require 'active_support/core_ext/hash/conversions'

require 'global_sign/version'
require 'global_sign/client'
require 'global_sign/contract'
require 'global_sign/request_xml_builder'
require 'global_sign/request'
require 'global_sign/response'
require 'global_sign/order_status'

require 'global_sign/url_verification'
require 'global_sign/url_verification_for_issue'
require 'global_sign/order_getter_by_order_id'
require 'global_sign/dns_verification'
require 'global_sign/dns_verification_for_issue'

module GlobalSign
  class << self
    attr_accessor :configuration, :contract

    def configure
      @configuration ||= Configuration.new
      yield @configuration if block_given?
    end

    def set_contract
      # initialize with nil, because the initialize method requires keyword args
      @contract ||= Contract.new(first_name: nil, last_name: nil, phone_number: nil, email: nil)
      yield @contract if block_given?
    end
  end

  class Configuration
    attr_accessor :user_name, :password, :endpoint
  end
end
