require 'nokogiri'

module GlobalSign
  class Response
    SUCCESS_CODE = '0'.freeze
    WARNING_CODE = '1'.freeze

    module XPath
      RESULT = '//Response/OrderResponseHeader/SuccessCode'
      ERRORS = '//Response/OrderResponseHeader/Errors'
    end

    def initialize(body)
      @xml = Nokogiri::XML(body)
    end

    def success?
      @xml.xpath(XPath::RESULT).text == SUCCESS_CODE
    end

    def warning?
      @xml.xpath(XPath::RESULT).text == WARNING_CODE
    end

    def error?
      !success?
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
      @xml.xpath(XPath::ERRORS)
    end
  end
end
