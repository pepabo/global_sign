$LOAD_PATH.unshift File.expand_path('../../lib', __FILE__)

require 'global_sign'

require 'dotenv'
require 'vcr'
require 'pry'

Dotenv.load

GlobalSign.configure do |configuration|
  configuration.user_name = ENV['USER_NAME']
  configuration.password  = ENV['PASSWORD']
  configuration.endpoint  = 'https://test-gcc.globalsign.com/kb/ws/v1'
end

VCR.configure do |configuration|
  configuration.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  configuration.hook_into :webmock
  configuration.filter_sensitive_data('[USER_NAME]') { ENV['USER_NAME'] }
  configuration.filter_sensitive_data('[PASSWORD]') {  ENV['PASSWORD'] }
end

def example_csr
  <<EOS
-----BEGIN CERTIFICATE REQUEST-----
MIICuDCCAaACAQAwczELMAkGA1UEBhMCSlAxDjAMBgNVBAgTBVRva3lvMRMwEQYD
VQQHEwpTaGlidXlhLWt1MRkwFwYDVQQKExBHTU8gUGVwYWJvLCBJbmMuMQowCAYD
VQQLEwEtMRgwFgYDVQQDEw93d3cuZXhhbXBsZS5jb20wggEiMA0GCSqGSIb3DQEB
AQUAA4IBDwAwggEKAoIBAQCwKGVMbfx6owwrM2bgsWaQvoGCCSuxscq/PyGOMWuW
whZ+Q6sPZJNNyb41jE1LgFgD4a3ku8JhdGjsjGVPi+9/OuGK9IISRMTwUsorwHKS
C8hV6T2CBEKdayrZZ6695Mc9jLhn6tqLHRql1lAKXwTBbaDsdyftuMo73AhpjVBL
4M2c/lsJWaE0K1S1QORckNwZ1FyDYzX04Urz1IdnJ3wF+bRsN1xQUs2QjFlxA4Ot
dqqvIN9oY9wVaNEBZMBAcX5bHPgq7s4BnkoyDh4/7HycNmzK2Z6HzcNvfic/Apvf
6+jkBJztEeRo7F1XDj8grOczFX1jUasazI+kn6IdMzTvAgMBAAGgADANBgkqhkiG
9w0BAQUFAAOCAQEAV66uWDxCpmvqpYU+ISG4kfxv74o1jxLpjrS07Owfvxt0/mik
cFHR+nIDCaHKhgOfJIS9xCvMWIkmHyRih/XK9yCUpmbkOKj2704E0O2FUZiNDZ9x
02gufWbtYw8s4ReKewejPtQ6L8SY2QgE5kBvEW3W+ZLTK1EE3LsX6eRCabxOVgAJ
ehacXTKnkLVndPImstQHq0iKM3ScUuIYpKodM7rVugjTiBt0cKe6dERoTQqWr+gH
gUktKs5ENeEWEW4Gepr3XBUTV4ViP29i/pYCMZc294hhx9Y0ggXPceKNBaqeHsYt
fTyAz1FGQxpdac76Jp9EO1xnzGCnPp9A3ACneg==
-----END CERTIFICATE REQUEST-----
EOS
end
