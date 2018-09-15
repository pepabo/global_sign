module GlobalSign
  module OVOrder
    class Request < GlobalSign::Request
      KIND_RENEWAL = 'renewal'.freeze

      def initialize(product_code: 'OV', order_kind:, validity_period_months:, csr:, renewal_target_order_id: nil, contract_info: nil, organization_info:)
        @product_code            = product_code
        @order_kind              = order_kind
        @validity_period_months  = validity_period_months
        @csr                     = csr
        @renewal_target_order_id = renewal_target_order_id
        @contract_info           = contract_info || GlobalSign.contract
        @organization_info       = organization_info
      end

      def path
        'ServerSSLService'
      end

      def action
        'OVOrder'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        @params = {
          OrderRequestParameter: order_request_parameter,
          ContactInfo: contact_info,
          OrganizationInfo: organization_info
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

      def organization_info
        {
          OrganizationName:    @organization_info.organization_name,
          CreditAgency:        @organization_info.credit_agency,
          OrganizationCode:    @organization_info.organization_code,
          OrganizationAddress: @organization_info.organization_address
        }
      end

      def renew?
        @order_kind == KIND_RENEWAL
      end
    end
  end
end
