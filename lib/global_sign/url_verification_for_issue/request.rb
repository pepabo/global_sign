module GlobalSign
  module UrlVerificationForIssue
    class Request < GlobalSign::Request
      def initialize(order_id:, approver_url:)
        @order_id     = order_id
        @approver_url = approver_url
      end

      def path
        'ServerSSLService'
      end

      def action
        'URLVerificationForIssue'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        {
          OrderID:     @order_id,
          ApproverURL: @approver_url,
        }
      end
    end
  end
end
