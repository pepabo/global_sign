require 'spec_helper'

describe GlobalSign::DnsVerification::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Pepabo',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'pepabo.taro@example.com',
    )
  end

  context 'when requested a new certificate' do
    before do
      VCR.use_cassette('dns_verification/new/' + cassette_title) do
        @response = client.process(request)
      end
    end

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      let(:request) do
        GlobalSign::DnsVerification::Request.new(
          product_code:           'DV_LOW_DNS',
          order_kind:             'new',
          validity_period_months: 6,
          csr:                    example_csr,
          contract_info:          contract,
        )
      end

      it 'succeeds' do
        expect(@response.success?).to be_truthy
        expect(@response.error_code).to be_nil
        expect(@response.error_field).to be_nil
        expect(@response.error_message).to be_nil
      end

      it 'returns response includes dns_verification params' do
        expect(@response.params[:order_id]).to be_present
        expect(@response.params[:dns_txt]).to be_present
        expect(@response.params[:verification_fqdn_list]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      let(:request) do
        GlobalSign::DnsVerification::Request.new(
          product_code:           'DV_LOW_DNS',
          order_kind:             'invalid_kind',
          validity_period_months: 6,
          csr:                    example_csr,
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
      VCR.use_cassette('dns_verification/renewal/' + cassette_title) do
        @response = client.process(request)
      end
    end

    let(:order_id) { 'xxxx123456789' }

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      let(:request) do
        GlobalSign::DnsVerification::Request.new(
          product_code:            'DV_LOW_DNS',
          order_kind:              'renewal',
          validity_period_months:  6,
          csr:                     example_csr,
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

      it 'returns response includes dns_verification params' do
        expect(@response.params[:order_id]).to be_present
        expect(@response.params[:dns_txt]).to be_present
        expect(@response.params[:verification_fqdn_list]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      let(:request) do
        GlobalSign::DnsVerification::Request.new(
          product_code:            'DV_LOW_DNS',
          order_kind:              'renewal',
          validity_period_months:  6,
          csr:                     example_csr,
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
