module GlobalSign
  module DVApproverList
    class Request < GlobalSign::Request
      def initialize(fqdn)
        @fqdn = fqdn
      end

      def path
        'ServerSSLService'
      end

      def action
        'GetDVApproverList'
      end

      def request_header
        :QueryRequestHeader
      end

      def params
        {
          FQDN: @fqdn
        }
      end
    end
  end
end
