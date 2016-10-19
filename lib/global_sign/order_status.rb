module GlobalSign
  class OrderStatus
    STATUS_MAPPING = {
      '1' => 'initial',
      '2' => 'phishing_checking',
      '3' => 'cancelled_not_issued',
      '4' => 'issue_completed',
      '5' => 'cancelled_issued',
      '6' => 'revoking',
      '7' => 'revoked',
    }.each_value(&:freeze).freeze
  end
end
