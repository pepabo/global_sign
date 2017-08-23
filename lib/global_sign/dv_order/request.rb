module GlobalSign
  module DVOrder
    class Request < GlobalSign::Request
      KIND_RENEWAL = 'renewal'.freeze

      def initialize(product_code:, order_kind:, validity_period_months:, csr:, approver_email:, order_id:, renewal_target_order_id: nil, contract_info: nil)
        @product_code            = product_code
        @order_kind              = order_kind
        @validity_period_months  = validity_period_months
        @csr                     = csr
        @approver_email          = approver_email
        @order_id                = order_id
        @renewal_target_order_id = renewal_target_order_id
        @contract_info           = contract_info || GlobalSign.contract
      end

      def path
        'ServerSSLService'
      end

      def action
        'DVOrder'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        @params = {
          OrderRequestParameter: order_request_parameter,
          OrderID: @order_id,
          ApproverEmail: @approver_email,
          ContactInfo: contact_info
        }
      end

      private

      def order_request_parameter
        request_params.tap do |params|
          params[:RenewalTargetOrderID] = @renewal_target_order_id if renew?
        end
      end

      def request_params
        {
          ProductCode: @product_code,
          OrderKind:   @order_kind,
          Licenses:    1,
          ValidityPeriod: {
            Months: @validity_period_months
          },
          CSR: @csr
        }
      end

      def contact_info
        {
          FirstName: @contract_info.first_name,
          LastName:  @contract_info.last_name,
          Phone:     @contract_info.phone_number,
          Email:     @contract_info.email
        }
      end

      def renew?
        @order_kind == KIND_RENEWAL
      end
    end
  end
end
