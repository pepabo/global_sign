module GlobalSign
  class OrganizationInfoEV
    attr_accessor :credit_agency, :organization_code, :business_assumed_name, :business_category_code, :organization_address


    def initialize(credit_agency: nil, organization_code: nil, business_assumed_name: nil, business_category_code:, organization_address:)
      @credit_agency          = credit_agency
      @organization_code      = organization_code
      @business_assumed_name  = business_assumed_name
      @business_category_code = business_category_code
      @organization_address   = organization_address_params(organization_address)
    end

    def organization_address_params(organization_address)
      {
        AddressLine1: organization_address.address_line1,
        AddressLine2: organization_address.address_line2,
        AddressLine3: organization_address.address_line3,
        City:         organization_address.city,
        Region:       organization_address.region,
        PostalCode:   organization_address.postal_code,
        Country:      organization_address.country,
        Phone:        organization_address.phone,
        Fax:          organization_address.fax
      }
    end
  end
end
