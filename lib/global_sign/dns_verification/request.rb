module GlobalSign
  module DnsVerification
    class Request < GlobalSign::UrlVerification::Request
      def initialize(product_code:, order_kind:, validity_period_months:, csr:, renewal_target_order_id: nil, contract_info: nil)
        @product_code            = product_code
        @order_kind              = order_kind
        @validity_period_months  = validity_period_months
        @csr                     = csr
        @renewal_target_order_id = renewal_target_order_id
        @contract_info           = contract_info || GlobalSign.contract
      end

      def path
        'ServerSSLService'
      end

      def action
        'DVDNSOrder'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        _params = {
          OrderRequestParameter: {
            ProductCode: @product_code,
            OrderKind:   @order_kind,
            Licenses:    1,
            ValidityPeriod: {
              Months: @validity_period_months
            },
            CSR: @csr,
          },
          ContactInfo: {
            FirstName: @contract_info.first_name,
            LastName:  @contract_info.last_name,
            Phone:     @contract_info.phone_number,
            Email:     @contract_info.email
          }
        }

        # require `RenewalTargetOrderID` to request a renewal certificate
        if @order_kind == 'renewal'
          _params[:OrderRequestParameter].merge!(
            { RenewalTargetOrderID: @renewal_target_order_id }
          )
        end

        _params
      end
    end
  end
end
