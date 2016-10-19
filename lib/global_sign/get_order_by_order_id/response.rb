module GlobalSign
  module GetOrderByOrderId
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID            = '//Response/OrderID'
        ORDER_STATUS        = '//Response/OrderDetail/OrderInfo/OrderStatus'
        MODIFICATION_EVENTS = '//Response/OrderDetail/ModificationEvents'
      end

      def params
        @params ||= {
          order_id:            @xml.xpath(XPath::ORDER_ID).text,
          order_status:        @xml.xpath(XPath::ORDER_STATUS).text,
          modification_events: modification_events_list
        }
      end

      private

      def modification_events_list
        @xml.xpath(XPath::MODIFICATION_EVENTS).children.map do |e|
          {
            name:      e.at('ModificationEventName').text,
            timestamp: e.at('ModificationEventTimestamp').text,
          }
        end
      end
    end
  end
end
