module GlobalSign
  module UrlVerification
    class Request < GlobalSign::Request
      def initialize(order_kind:, validity_period_m:, csr:, contract_info: nil)
        @order_kind        = order_kind
        @validity_period_m = validity_period_m
        @csr               = csr
        @contract_info     = contract_info || GlobalSign.contract_information
      end

      def path
        'ServerSSLService'
      end

      def action
        'URLVerification'
      end

      def params
        {
          OrderRequestParameter: {
            ProductCode: 'DV_LOW_URL',
            OrderKind:   @order_kind,
            Licenses:    1,
            ValidityPeriod: {
              Months: @validity_period_m
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
      end
    end
  end
end
