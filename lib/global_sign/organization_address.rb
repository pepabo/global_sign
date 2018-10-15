module GlobalSign
  class OrganizationAddress
    attr_accessor :address_line1, :address_line2, :address_line3, :city, :region, :postal_code, :country, :phone, :fax

    def initialize(address_line1:, address_line2: nil, address_line3: nil, city:, region:, postal_code:, country:, phone:, fax: nil)
      @address_line1 = address_line1
      @address_line2 = address_line2
      @address_line3 = address_line3
      @city          = city
      @region        = region
      @postal_code   = postal_code
      @country       = country
      @phone         = phone
      @fax           = fax
    end
  end
end
