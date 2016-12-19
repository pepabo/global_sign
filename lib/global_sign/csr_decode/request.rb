module GlobalSign
  module CsrDecode
    class Request < GlobalSign::Request
      def initialize(csr:, product_type:)
        @csr = csr
        @product_type = product_type
      end

      def path
        'GASService'
      end

      def action
        'DecodeCSR'
      end

      def request_header
        :QueryRequestHeader
      end

      def params
        {
          CSR: @csr,
          ProductType: @product_type
        }
      end
    end
  end
end
