require "global_sign/version"

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
