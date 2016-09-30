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
      # initialize with nil, because the initialize method requires keyword args
      @contract_information ||= Contract.new(first_name: nil, last_name: nil, phone_number: nil, email: nil)
      yield @contract_information if block_given?
    end
  end

  class Configuration
    attr_accessor :user_name, :password, :endpoint
  end

  class Contract
    attr_accessor :first_name, :last_name, :phone_number, :email

    def initialize(first_name:, last_name:, phone_number:, email:)
      @first_name   = first_name
      @last_name    = last_name
      @phone_number = phone_number
      @email        = email
    end
  end
end
