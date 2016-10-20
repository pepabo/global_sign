module GlobalSign
  class OrderStatus
    STATUS_MAPPING = {
      '1' => 'initial',
      '2' => 'waiting_for_phishing_check',
      '3' => 'cancelled_before_issue',
      '4' => 'completed_issue',
      '5' => 'cancelled_after_issue',
      '6' => 'waiting_for_certificate_revocation',
      '7' => 'revoked_certificate',
    }.each_value(&:freeze).freeze
  end
end
