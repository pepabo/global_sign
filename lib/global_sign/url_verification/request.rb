module GlobalSign
  module UrlVerification
    class Request < GlobalSign::Request
      def initialize(
        order_kind:,
        validity_period_months:,
        csr:,
        renewal_target_order_id: nil,
        contract_info:           nil)

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
        'URLVerification'
      end

      def params
        _params = {
          OrderRequestParameter: {
            ProductCode: 'DV_LOW_URL',
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
        _params.tap {|h|
          if @order_kind == 'renewal'
            h[:OrderRequestParameter][:RenewalTargetOrderID] = @renewal_target_order_id
          end
        }
      end
    end
  end
end
