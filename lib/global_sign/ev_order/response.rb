module GlobalSign
  module EVOrder
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID = '//Response/OrderID'.freeze
      end

      def response_header
        :OrderResponseHeader
      end

      def params
        @params ||= {
          order_id: @xml.xpath(XPath::ORDER_ID).text
        }
      end
    end
  end
end
