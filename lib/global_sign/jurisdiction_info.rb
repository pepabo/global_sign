module GlobalSign
  class JurisdictionInfo
    attr_accessor :jurisdiction_country, :state_or_province, :locality, :incorporating_agency_registration_number

    def initialize(jurisdiction_country:, state_or_province:, locality:, incorporating_agency_registration_number:)
      @jurisdiction_country                     = jurisdiction_country
      @state_or_province                        = state_or_province
      @locality                                 = locality
      @incorporating_agency_registration_number = incorporating_agency_registration_number
    end
  end
end
