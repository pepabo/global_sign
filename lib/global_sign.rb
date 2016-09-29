require 'active_support/core_ext/hash/conversions'

require 'global_sign/version'
require 'global_sign/client'
require 'global_sign/request_xml_builder'
require 'global_sign/request'
require 'global_sign/response'

require 'global_sign/url_verification'

module GlobalSign
  class << self
    attr_accessor :configuration, :contract_information

    def configure
      @configuration ||= Configuration.new
      yield @configuration if block_given?
    end

    def contract
      @contract_information ||= ContractInformation.new
      yield @contract_information if block_given?
    end
  end

  class Configuration
    attr_accessor :user_name, :password, :endpoint
  end

  class ContractInformation
    attr_accessor :first_name, :last_name, :phone_number, :email
  end
end
