require 'spec_helper'

describe GlobalSign::OVOrder::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Pepabo',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'pepabo.taro@example.com'
    )
  end
  let(:organization_info) do
    GlobalSign::OrganizationInfo.new(
      organization_name:    'CompanyName, Inc.',
      credit_agency:        GlobalSign::OrganizationInfo::CreditAgency::TDB,
      organization_code:    111,
      organization_address: GlobalSign::OrganizationAddress.new(
        address_line1: '26-1',
        city:          'Shibuya',
        region:        'Tokyo',
        postal_code:   '150-0031',
        country:       'JP',
        phone:         '090-1234-5678'
      )
    )
  end
  let(:csr) { example_csr }
  let(:id) { 'xxxx123456789' }

  context 'when requested a new certificate' do
    let(:request) do
      GlobalSign::OVOrder::Request.new(
        order_kind: 'new',
        validity_period_months: 12,
        csr: csr,
        contract_info: contract,
        organization_info: organization_info
      )
    end

    subject do
      VCR.use_cassette('ov_order/new/' + cassette_title) do
        client.process(request)
      end
    end

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      it 'succeeds' do
        expect(subject.success?).to be_truthy
        expect(subject.error_code).to be_nil
        expect(subject.error_field).to be_nil
        expect(subject.error_message).to be_nil
      end

      it 'returns response with order id' do
        expect(subject.params[:order_id]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      it 'specifies the error' do
        expect(subject.success?).to be_falsy
        expect(subject.error_code).to_not be_nil
        expect(subject.error_field).to_not be_nil
        expect(subject.error_message).to_not be_nil
      end

      it 'returns empty order id' do
        expect(subject.params[:order_id]).to be_empty
      end
    end
  end

  context 'when requested a renewal certificate' do
    let(:renewal_target_order_id) { id }
    let(:request) do
      GlobalSign::OVOrder::Request.new(
        order_kind: 'renewal',
        validity_period_months: 12,
        csr: csr,
        contract_info: contract,
        organization_info: organization_info,
        renewal_target_order_id: renewal_target_order_id
      )
    end

    subject do
      VCR.use_cassette('ov_order/renewal/' + cassette_title) do
        @response = client.process(request)
      end
    end

    context 'when returned success response' do
      let(:cassette_title) { 'success' }

      it 'succeeds' do
        expect(subject.success?).to be_truthy
        expect(subject.error_code).to be_nil
        expect(subject.error_field).to be_nil
        expect(subject.error_message).to be_nil
      end

      it 'returns response with order id' do
        expect(subject.params[:order_id]).to be_present
      end
    end

    context 'when returned error response' do
      let(:cassette_title) { 'failure' }

      it 'specifies the error' do
        expect(subject.success?).to be_falsy
        expect(subject.error_code).to_not be_nil
        expect(subject.error_field).to_not be_nil
        expect(subject.error_message).to_not be_nil
      end

      it 'returns empty order id' do
        expect(subject.params[:order_id]).to be_empty
      end
    end
  end
end
