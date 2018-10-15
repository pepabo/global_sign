require 'faraday'

module GlobalSign
  class Client
    def initialize(options: {})
      @configuration = GlobalSign.configuration

      @connection = Faraday::Connection.new(url: @configuration.endpoint) do |conn|
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
        conn.options[:timeout] = options[:timeout] if options[:timeout].present?
      end
    end

    def process(request)
      response_class = find_response_class_for(request)

      response = @connection.post do |req|
        req.url request.path
        req.headers['Content-Type'] = 'text/xml'
        req.body = request.to_xml
      end

      response_class.new(response.body)
    end

    def find_response_class_for(request)
      case request
      when GlobalSign::CsrDecoder::Request
        GlobalSign::CsrDecoder::Response
      when GlobalSign::DnsVerification::Request
        GlobalSign::DnsVerification::Response
      when GlobalSign::DnsVerificationForIssue::Request
        GlobalSign::DnsVerificationForIssue::Response
      when GlobalSign::UrlVerification::Request
        GlobalSign::UrlVerification::Response
      when GlobalSign::UrlVerificationForIssue::Request
        GlobalSign::UrlVerificationForIssue::Response
      when GlobalSign::OrderGetterByOrderId::Request
        GlobalSign::OrderGetterByOrderId::Response
      when GlobalSign::DVApproverList::Request
        GlobalSign::DVApproverList::Response
      when GlobalSign::DVOrder::Request
        GlobalSign::DVOrder::Response
      when GlobalSign::OVOrder::Request
        GlobalSign::OVOrder::Response
      else
        raise ArgumentError, 'invalid request argument'
      end
    end
  end
end
