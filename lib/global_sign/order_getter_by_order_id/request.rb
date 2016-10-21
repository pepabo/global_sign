module GlobalSign
  module OrderGetterByOrderId
    class Request < GlobalSign::Request
      def initialize(order_id:)
        @order_id = order_id
      end

      def path
        'GASService'
      end

      def action
        'GetOrderByOrderID'
      end

      def request_header
        :QueryRequestHeader
      end

      def params
        { OrderID: @order_id }
      end
    end
  end
end
