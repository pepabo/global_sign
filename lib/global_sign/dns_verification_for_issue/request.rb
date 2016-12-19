module GlobalSign
  module DnsVerificationForIssue
    class Request < GlobalSign::Request
      def initialize(order_id:, approver_fqdn:)
        @order_id     = order_id
        @approver_fqdn = approver_fqdn
      end

      def path
        'ServerSSLService'
      end

      def action
        'DVDNSVerificationForIssue'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        {
          OrderID:      @order_id,
          ApproverFQDN: @approver_fqdn,
        }
      end
    end
  end
end
