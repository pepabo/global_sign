module GlobalSign
  module UrlVerification
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID              = '//Response/OrderID'
        META_TAG              = '//Response/MetaTag'
        VERIFICATION_URL_LIST = '//Response/VerificationURLList'
      end

      def response_header
        :OrderResponseHeader
      end

      def params
        @params ||= {
          order_id:              @xml.xpath(XPath::ORDER_ID).text,
          meta_tag:              @xml.xpath(XPath::META_TAG).text,
          verification_url_list: verification_url_list,
        }
      end

      private

      def verification_url_list
        @xml.xpath(XPath::VERIFICATION_URL_LIST).children.map(&:text)
      end
    end
  end
end
