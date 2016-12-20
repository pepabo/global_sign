require 'nokogiri'

module GlobalSign
  class Response
    SUCCESS_CODE = '0'.freeze
    WARNING_CODE = '1'.freeze

    def initialize(body)
      @xml = Nokogiri::XML(body)
    end

    def xpath_result
      "//Response/#{response_header}/SuccessCode"
    end

    def xpath_errors
      "//Response/#{response_header}/Errors"
    end

    def success?
      @xml.xpath(xpath_result).text == SUCCESS_CODE
    end

    def warning?
      @xml.xpath(xpath_result).text == WARNING_CODE
    end

    def error?
      !success? && !warning?
    end

    def error_code
      errors.at('ErrorCode').try(:text)
    end

    def error_field
      errors.at('ErrorField').try(:text)
    end

    def error_message
      errors.at('ErrorMessage').try(:text)
    end

    private

    def errors
      @xml.xpath(xpath_errors)
    end
  end
end
