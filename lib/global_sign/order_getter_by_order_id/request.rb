module GlobalSign
  module OrderGetterByOrderId
    class Request < GlobalSign::Request
      def initialize(order_id:, options: nil)
        @order_id = order_id
        @options  = options
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
        _params = { OrderID: @order_id }
        _params[:OrderQueryOption] = @options if @options
        _params
      end
    end
  end
end
