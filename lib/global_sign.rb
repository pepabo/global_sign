require 'active_support/core_ext/hash/conversions'

require 'global_sign/version'
require 'global_sign/client'
require 'global_sign/contract'
require 'global_sign/request_xml_builder'
require 'global_sign/request'
require 'global_sign/response'

require 'global_sign/url_verification'
require 'global_sign/url_verification_for_issue'

module GlobalSign
  class << self
    attr_accessor :configuration, :contract

    def configure
      @configuration ||= Configuration.new
      yield @configuration if block_given?
    end

    def set_contract
      @contract ||= Contract.new
      yield @contract if block_given?
    end
  end

  class Configuration
    attr_accessor :user_name, :password, :endpoint
  end
end
