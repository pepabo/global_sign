module GlobalSign
  module OrderGetterByOrderId
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

      def order_status_text
        OrderStatus::STATUS_MAPPING[params[:order_status]]
      end

      private

      def modification_events_list
        @xml.xpath(XPath::MODIFICATION_EVENTS).children.map do |element|
          {
            name:      element.at('ModificationEventName').text,
            timestamp: element.at('ModificationEventTimestamp').text,
          }
        end
      end
    end
  end
end
