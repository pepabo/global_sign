require 'spec_helper'

describe GlobalSign::EVOrder::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Example',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'taro@example.com'
    )
  end
  let(:organization_info_ev) do
    GlobalSign::OrganizationInfoEV.new(
      organization_code:     '123456789',
      business_category_code: GlobalSign::OrganizationInfoEV::BusinessCategoryCode::PRIVATE_ORGANIZATION,
      organization_address:   GlobalSign::OrganizationAddress.new(
        address_line1: '26-1',
        city:          'Shibuya',
        region:        'Tokyo',
        postal_code:   '150-0031',
        country:       'JP',
        phone:         '090-1234-5678'
      )
    )
  end
  let(:requestor_info) do
    GlobalSign::RequestorInfo.new(
      first_name:        'Example',
      last_name:         'Requestor',
      organization_name: 'CompanyName, Inc.',
      phone_number:      '090-1234-5678',
      email:             'requestor@example.com'
    )
  end
  let(:approver_info) do
    GlobalSign::ApproverInfo.new(
      first_name:        'Example',
      last_name:         'Approver',
      organization_name: 'CompanyName, Inc.',
      phone_number:      '090-1234-5678',
      email:             'approver@example.com'
    )
  end
  let(:authorized_signer_info) do
    GlobalSign::AuthorizedSignerInfo.new(
      first_name:        'Example',
      last_name:         'AuthorizedSigner',
      organization_name: 'CompanyName, Inc.',
      phone_number:      '090-1234-5678',
      email:             'authorized_signer@example.com'
    )
  end
  let(:jurisdiction_info) do
    GlobalSign::JurisdictionInfo.new(
      jurisdiction_country:                     'JP',
      state_or_province:                        'Tokyo',
      locality:                                 'Shibuya',
      incorporating_agency_registration_number: '1234-12-123456'
    )
  end
  let(:csr) { example_csr }
  let(:id) { 'xxxx123456789' }

  context 'when requested a new certificate' do
    let(:request) do
      GlobalSign::EVOrder::Request.new(
        order_kind: 'new',
        validity_period_months: 12,
        csr: csr,
        contract_info: contract,
        organization_info_ev: organization_info_ev,
        requestor_info: requestor_info,
        approver_info: approver_info,
        authorized_signer_info: authorized_signer_info,
        jurisdiction_info: jurisdiction_info
      )
    end

    subject do
      VCR.use_cassette('ev_order/new/' + cassette_title) do
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
      GlobalSign::EVOrder::Request.new(
        order_kind: 'renewal',
        validity_period_months: 12,
        csr: csr,
        contract_info: contract,
        organization_info_ev: organization_info_ev,
        requestor_info: requestor_info,
        approver_info: approver_info,
        authorized_signer_info: authorized_signer_info,
        jurisdiction_info: jurisdiction_info,
        renewal_target_order_id: renewal_target_order_id
      )
    end

    subject do
      VCR.use_cassette('ev_order/renewal/' + cassette_title) do
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
