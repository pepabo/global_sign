module GlobalSign
  module DnsVerification
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID               = '//Response/OrderID'
        DNS_TXT                = '//Response/DNSTXT'
        VERIFICATION_FQDN_LIST = '//Response/VerificationFQDNList'
      end

      def response_header
        :OrderResponseHeader
      end

      def params
        @params ||= {
          order_id:               @xml.xpath(XPath::ORDER_ID).text,
          dns_txt:                @xml.xpath(XPath::DNS_TXT).text,
          verification_fqdn_list: verification_fqdn_list,
        }
      end

      private

      def verification_fqdn_list
        @xml.xpath(XPath::VERIFICATION_FQDN_LIST).children.map(&:text)
      end
    end
  end
end
