# GlobalSign

A Ruby interface to the GlobalSign API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'global_sign'
```

And then execute:

```
$ bundle
```

Or install it yourself as:

```
$ gem install global_sign
```

## Usage

### Configuration

An example initializer would look something like this:

```ruby
GlobalSign.configure do |configuration|
  configuration.user_name = 'PAR12345_taro'
  configuration.password  = 'password'
  configuration.endpoint  = 'https://test-gcc.globalsign.com/kb/ws/v1'
end
```

### URL Verification

```ruby
require 'global_sign'

client = GlobalSign::Client.new

# Prepare CSR beforehand
csr = <<-EOS
-----BEGIN CERTIFICATE REQUEST-----
...
-----END CERTIFICATE REQUEST-----
EOS

contract = GlobalSign::Contract.new(
  first_name:   'Pepabo',
  last_name:    'Taro',
  phone_number: '090-1234-5678',
  email:        'pepabo.taro@example.com',
)

request = GlobalSign::UrlVerification::Request.new(
  order_kind:             'new',   # If you request a new certificate
  validity_period_months: 6,
  csr:                    csr,
  contract_info:          contract,
)

response = client.process(request)

if response.success?
  puts "Successfully URL Verification"
  puts response.params # => { meta_tag: "xxxxx", ... }
else
  raise StandardError, "#{response.error_code}: #{response.error_message}"
end
```

It's also possible to set contract within your configure block.

```ruby
GlobalSign.set_contract do |contract|
  contract.first_name   = 'Pepabo'
  contract.last_name    = 'Taro'
  contract.phone_number = '090-1234-5678'
  contract.email        = 'pepabo.taro@example.com'
end

# Not need to give the argument 'contract_info'
request = GlobalSign::UrlVerification::Request.new(
  order_kind:             'new',
  validity_period_months: 6,
  csr:                    csr,
)
```

If you request a renewal certificate, you should set `renewal` to the value of argument `order_kind`.  
And you should give the argument `renewal_target_order_id` .

```ruby
request = GlobalSign::UrlVerification::Request.new(
  order_kind:              'renewal',
  validity_period_months:  6,
  csr:                     csr,
  renewal_target_order_id: 'xxxx123456789',
  contract_info:           contract,
)
```

### URL Verification for Issue

```ruby
client = GlobalSign::Client.new

# You can use ApproverURL value such as:
# - http://example.com
# - https://example.com
# - http://www.example.com
# - https://www.example.com

request = GlobalSign::UrlVerificationForIssue::Request.new(
  order_id:     'xxxx123456789',
  approver_url: 'http://example.com',
)

response = client.process(request)

if response.success?
  puts "Successfully URL Verification for Issue"
  puts response.params # => { fulfillment: { ca_certificates: [{ ca_cert: "xxxxx" }, ...]}, ... }
else
  raise StandardError, "#{response.error_code}: #{response.error_message}"
end
```

### Get Order by OrderID

```ruby
request = GlobalSign::GetOrderByOrderId::Request.new(order_id: 'xxxx123456789')
response = client.process(request)

puts response.params # => { order_id: "xxxx123456789", order_status: "2", ... }

# You can get order_status explanation
puts response.order_status  # => "phishing_checking"
```

## Contributing

1. Create your feature branch (git checkout -b my-new-feature)
2. Commit your changes (git commit -am 'Add some feature')
3. Push to the branch (git push origin my-new-feature)
4. Create a new Pull Request
