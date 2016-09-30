require 'spec_helper'

describe GlobalSign::UrlVerification::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract_information) { GlobalSign.contract_information }

  before do
    GlobalSign.contract do |contract_information|
      contract_information.first_name = 'Pepabo'
      contract_information.last_name = 'Taro'
      contract_information.phone_number = '090-1234-5678'
      contract_information.email = 'test@example.com'
    end

    VCR.use_cassette('url_verification/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returning success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::UrlVerification::Request.new(
        order_kind: 'new',
        csr: '-----BEGIN CERTIFICATE REQUEST-----
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
-----END CERTIFICATE REQUEST-----',
        contract_info: contract_information,
      )
    end

    it 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'response includes url_verification params' do
      expect(@response.params[:order_id]).to be_present
      expect(@response.params[:meta_tag]).to be_present
      expect(@response.params[:verification_url_list]).to be_present
    end
  end

  context 'when returning error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::UrlVerification::Request.new(
        order_kind: 'invalid_kind',
        csr: '-----BEGIN CERTIFICATE REQUEST-----
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
-----END CERTIFICATE REQUEST-----',
        contract_info: contract_information,
      )
    end

    it 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-103')
      expect(@response.error_field).to eq('OrderRequestParameter.OrderKind')
      expect(@response.error_message).to eq('Parameter length check error. Please check that the parameters match the API specification. Please review the specific ErrorMessage returned in the XML response for parameter details and consult the XML Field definitions section of the applicable API document.')
    end
  end
end
