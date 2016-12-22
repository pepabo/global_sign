module GlobalSign
  module OrderGetterByOrderId
    class Request < GlobalSign::Request
      def initialize(order_id:, options: {})
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

        # options
        option_params = {}
        option_params[:ReturnCertificateInfo] = true if @options[:certificate_info]
        option_params[:ReturnFulfillment]     = true if @options[:fulfillment]
        _params[:OrderQueryOption] = option_params   if option_params.present?

        _params
      end
    end
  end
end
