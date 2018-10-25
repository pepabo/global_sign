module GlobalSign
  module EVOrder
    class Request < GlobalSign::Request
      KIND_RENEWAL = 'renewal'.freeze

      def initialize(product_code: 'EV', order_kind:, validity_period_months:, csr:, renewal_target_order_id: nil, organization_info_ev:, requestor_info:, approver_info:, authorized_signer_info:, jurisdiction_info:, contract_info: nil)
        @product_code            = product_code
        @order_kind              = order_kind
        @validity_period_months  = validity_period_months
        @csr                     = csr
        @renewal_target_order_id = renewal_target_order_id
        @organization_info_ev    = organization_info_ev
        @requestor_info          = requestor_info
        @approver_info           = approver_info
        @authorized_signer_info  = authorized_signer_info
        @jurisdiction_info       = jurisdiction_info
        @contract_info           = contract_info || GlobalSign.contract
      end

      def path
        'ServerSSLService'
      end

      def action
        'EVOrder'
      end

      def request_header
        :OrderRequestHeader
      end

      def params
        @params = {
          OrderRequestParameter: order_request_parameter,
          OrganizationInfoEV:    organization_info_ev,
          RequestorInfo:         requestor_info,
          ApproverInfo:          approver_info,
          AuthorizedSignerInfo:  authorized_signer_info,
          JurisdictionInfo:      jurisdiction_info,
          ContactInfo:           contact_info
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

      def organization_info_ev
        {
          CreditAgency:         @organization_info_ev.credit_agency,
          OrganizationCode:     @organization_info_ev.organization_code,
          BusinessAssumedName:  @organization_info_ev.business_assumed_name,
          BusinessCategoryCode: @organization_info_ev.business_category_code,
          OrganizationAddress:  @organization_info_ev.organization_address
        }
      end

      def requestor_info
        {
          FirstName:        @requestor_info.first_name,
          LastName:         @requestor_info.last_name,
          Function:         @requestor_info.function,
          OrganizationName: @requestor_info.organization_name,
          OrganizationUnit: @requestor_info.organization_unit,
          Phone:            @requestor_info.phone_number,
          Email:            @requestor_info.email
        }
      end

      def approver_info
        {
          FirstName:        @approver_info.first_name,
          LastName:         @approver_info.last_name,
          Function:         @approver_info.function,
          OrganizationName: @approver_info.organization_name,
          OrganizationUnit: @approver_info.organization_unit,
          Phone:            @approver_info.phone_number,
          Email:            @approver_info.email
        }
      end

      def authorized_signer_info
        {
          FirstName:        @authorized_signer_info.first_name,
          LastName:         @authorized_signer_info.last_name,
          Function:         @authorized_signer_info.function,
          OrganizationName: @authorized_signer_info.organization_name,
          Phone:            @authorized_signer_info.phone_number,
          Email:            @authorized_signer_info.email
        }
      end

      def jurisdiction_info
        {
         JurisdictionCountry:                   @jurisdiction_info.jurisdiction_country,
         StateOrProvince:                       @jurisdiction_info.state_or_province,
         Locality:                              @jurisdiction_info.locality,
         IncorporatingAgencyRegistrationNumber: @jurisdiction_info.incorporating_agency_registration_number
        }
      end

      def renew?
        @order_kind == KIND_RENEWAL
      end
    end
  end
end
