## 2.1.1
- Fixed bug: `GlobalSign::OrderGetterByOrderId::Request` NoMethodError: undefined method `text' for nil:NilClass

## 2.1.0

- Support GlobalSign API: DecodeCSR
- Support GlobalSign API: DVDNSOrder & DVDNSVerificationForIssue
- Added `options` optional keyword argument to `GlobalSign::OrderGetterByOrderId::Request` for getting certificate info and fulfillment

## 2.0.0

- Added `product_code` required keyword argument to `GlobalSign::UrlVerification::Request` for selecting SSL certificate type

## 1.0.0

- Support GlobalSign API: URLVerification & URLVerificationForIssue
- Support GlobalSign API: GetOrderByOrderID
