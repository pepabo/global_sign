module GlobalSign
  class Contract
    attr_accessor :first_name, :last_name, :phone_number, :email

    def initialize(first_name:, last_name:, phone_number:, email:)
      @first_name   = first_name
      @last_name    = last_name
      @phone_number = phone_number
      @email        = email
    end
  end
end
