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

### Settings

An example Rails initializer would look something like this:

```ruby
GlobalSign.configure do |configuration|
  configuration.user_name = 'PAR12345_taro'
  configuration.password  = 'password'
  configuration.endpoint  = 'https://test-gcc.globalsign.com/kb/ws/v1'
end

GlobalSign.contract do |contract_information|
  contract_information.first_name   = 'Pepabo'
  contract_information.last_name    = 'Taro'
  contract_information.phone_number = '090-1234-5678'
  contract_information.email        = 'pepabo.taro@example.com'
end
```

### URL Verification

```ruby
require 'global_sign'

client = GlobalSign::Client.new

# Prepare CSR beforehand
csr = '-----BEGIN CERTIFICATE REQUEST-----
...
-----END CERTIFICATE REQUEST-----'

request = GlobalSign::UrlVerification::Request.new(
  order_kind:    'new',   # If you request a new certificate
  csr:           csr,
  contract_info: GlobalSign.contract_information,
)

response = client.process(request)

if response.success?
  puts "Successfully URL Verification"
  puts response.params # => { meta_tag: "xxxxx", ... }
else
  raise StandardError, "#{response.error_code}: #{response.error_message}"
end
```

## Contributing

1. Create your feature branch (git checkout -b my-new-feature)
2. Commit your changes (git commit -am 'Add some feature')
3. Push to the branch (git push origin my-new-feature)
4. Create a new Pull Request
