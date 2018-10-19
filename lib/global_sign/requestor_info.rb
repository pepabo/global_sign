module GlobalSign
  class RequestorInfo
    attr_accessor :first_name, :last_name, :function, :organization_name, :organization_unit, :phone_number, :email

    def initialize(first_name:, last_name:, function: nil, organization_name:, organization_unit: nil, phone_number:, email:)
      @first_name        = first_name
      @last_name         = last_name
      @function          = function
      @organization_name = organization_name
      @organization_unit = organization_unit
      @phone_number      = phone_number
      @email             = email
    end
  end
end
