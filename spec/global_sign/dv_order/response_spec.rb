require 'spec_helper'

describe GlobalSign::DVOrder::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Pepabo',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'pepabo.taro@example.com'
    )
  end
  let(:csr) { example_csr }
  let(:id) { 'xxxx123456789' }
  let(:approver_email) { 'admin@example.com' }

  context 'when requested a new certificate' do
    let(:order_id) { id }
    let(:request) do
      GlobalSign::DVOrder::Request.new(
        product_code: 'DV_LOW',
        order_kind: 'new',
        validity_period_months: 6,
        csr: csr,
        approver_email: approver_email,
        order_id: order_id,
        contract_info: contract
      )
    end

    subject do
      VCR.use_cassette('dv_order/new/' + cassette_title) do
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
    let(:order_id) { 'xxxx123456780' }
    let(:renewal_target_order_id) { id }
    let(:request) do
      GlobalSign::DVOrder::Request.new(
        product_code: 'DV_LOW',
        order_kind: 'renewal',
        validity_period_months: 6,
        csr: csr,
        approver_email: approver_email,
        order_id: order_id,
        contract_info: contract,
        renewal_target_order_id: renewal_target_order_id
      )
    end

    subject do
      VCR.use_cassette('dv_order/renewal/' + cassette_title) do
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
        expect(subject.error_field).to be_nil
        expect(subject.error_message).to_not be_nil
      end

      it 'returns empty order id' do
        expect(subject.params[:order_id]).to be_empty
      end
    end
  end
end
