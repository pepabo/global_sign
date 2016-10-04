module GlobalSign
  module UrlVerification
    class Request < GlobalSign::Request
      def initialize(order_kind:, validity_period:, csr:, contract_info: nil)
        @order_kind        = order_kind
        @validity_period   = validity_period
        @csr               = csr
        @contract_info     = contract_info || GlobalSign.contract
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
              Months: @validity_period
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
