require 'spec_helper'

describe GlobalSign::UrlVerification::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Pepabo',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'pepabo.taro@example.com',
    )
  end

  let(:csr) do
    <<-EOS
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

  context 'when requested a new certificate' do
    before do
      VCR.use_cassette('url_verification/new/' + cassette_title) do
        @response = client.process(request)
      end
    end

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      let(:request) do
        GlobalSign::UrlVerification::Request.new(
          order_kind:             'new',
          validity_period_months: 1,
          csr:                    csr,
          contract_info:          contract,
        )
      end

      it 'succeeds' do
        expect(@response.success?).to be_truthy
        expect(@response.error_code).to be_nil
        expect(@response.error_field).to be_nil
        expect(@response.error_message).to be_nil
      end

      it 'returns response includes url_verification params' do
        expect(@response.params[:order_id]).to be_present
        expect(@response.params[:meta_tag]).to be_present
        expect(@response.params[:verification_url_list]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      let(:request) do
        GlobalSign::UrlVerification::Request.new(
          order_kind:             'invalid_kind',
          validity_period_months: 1,
          csr:                    csr,
          contract_info:          contract,
        )
      end

      it 'fails' do
        expect(@response.error?).to be_truthy
        expect(@response.error_code).to eq('-103')
        expect(@response.error_field).to eq('OrderRequestParameter.OrderKind')
        expect(@response.error_message).to include('Parameter length check error.')
      end
    end
  end

  context 'when requested a renewal certificate' do
    before do
      VCR.use_cassette('url_verification/renewal/' + cassette_title) do
        @response = client.process(request)
      end
    end

    let(:order_id) { 'xxxx123456789' }

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      let(:request) do
        GlobalSign::UrlVerification::Request.new(
          order_kind:              'renewal',
          validity_period_months:  1,
          csr:                     csr,
          renewal_target_order_id: order_id,
          contract_info:           contract,
        )
      end

      it 'succeeds' do
        expect(@response.success?).to be_truthy
        expect(@response.error_code).to be_nil
        expect(@response.error_field).to be_nil
        expect(@response.error_message).to be_nil
      end

      it 'returns response includes url_verification params' do
        expect(@response.params[:order_id]).to be_present
        expect(@response.params[:meta_tag]).to be_present
        expect(@response.params[:verification_url_list]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      let(:request) do
        GlobalSign::UrlVerification::Request.new(
          order_kind:              'renewal',
          validity_period_months:  1,
          csr:                     csr,
          renewal_target_order_id: order_id,
          contract_info:           contract,
        )
      end

      it 'fails' do
        expect(@response.error?).to be_truthy
        expect(@response.error_code).to eq('-6102')
        expect(@response.error_message).to include('The renewal of the certificate failed.')
      end
    end
  end
end
