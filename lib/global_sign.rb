require 'active_support/core_ext/hash/conversions'

require 'global_sign/version'
require 'global_sign/client'
require 'global_sign/contract'
require 'global_sign/organization_address'
require 'global_sign/organization_info'
require 'global_sign/organization_info/credit_agency'
require 'global_sign/organization_info_ev'
require 'global_sign/organization_info_ev/business_category_code'
require 'global_sign/requestor_info'
require 'global_sign/approver_info'
require 'global_sign/authorized_signer_info'
require 'global_sign/jurisdiction_info'
require 'global_sign/request_xml_builder'
require 'global_sign/request'
require 'global_sign/response'
require 'global_sign/order_status'

require 'global_sign/url_verification'
require 'global_sign/url_verification_for_issue'
require 'global_sign/order_getter_by_order_id'
require 'global_sign/csr_decoder'
require 'global_sign/dns_verification'
require 'global_sign/dns_verification_for_issue'
require 'global_sign/dv_approver_list'
require 'global_sign/dv_order'
require 'global_sign/ov_order'
require 'global_sign/ev_order'

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
