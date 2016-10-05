require 'faraday'

module GlobalSign
  class Client
    def initialize
      @configuration = GlobalSign.configuration

      @connection = Faraday::Connection.new(url: @configuration.endpoint) do |conn|
        conn.request :url_encoded
        conn.adapter Faraday.default_adapter
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
      when GlobalSign::UrlVerification::Request
        GlobalSign::UrlVerification::Response
      else
        raise ArgumentError, 'invalid request argument'
      end
    end
  end
end
