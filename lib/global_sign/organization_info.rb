module GlobalSign
  class OrganizationInfo
    attr_accessor :organization_name, :credit_agency, :organization_code, :organization_address

    def initialize(organization_name:, credit_agency: nil, organization_code: nil, organization_address:)
      @organization_name    = organization_name
      @credit_agency        = credit_agency
      @organization_code    = organization_code
      @organization_address = organization_address_params(organization_address)
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
