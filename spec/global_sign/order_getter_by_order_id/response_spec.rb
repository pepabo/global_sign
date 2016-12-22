require 'spec_helper'

describe GlobalSign::OrderGetterByOrderId::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('order_getter_by_order_id/' + cassette_title) do
      @response = client.process(request)
    end
  end

  shared_examples_for 'succeeds' do
    it do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'response includes order_getter_by_order_id params' do
      expect(@response.params[:order_id]).to be_present
      expect(@response.params[:order_status]).to be_present
      expect(@response.params[:modification_events]).to be_present
    end

    it 'returns order_status text' do
      expect(@response.order_status_text).to eq(order_status)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }
    let(:order_status) { 'initial' }

    let(:request) do
      GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789')
    end

    it_behaves_like 'succeeds'

    it 'not exists option responses' do
      expect(@response.params[:certificate_info]).to be_nil
      expect(@response.params[:fulfillment]).to be_nil
    end
  end

  context 'when returned success response with certificate_info option' do
    let(:cassette_title) { 'with_certificate_info' }
    let(:order_status) { 'completed_issue' }

    let(:request) do
      GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789', options: {certificate_info: true})
    end

    it_behaves_like 'succeeds'

    it 'exists certificate_info option response' do
      expect(@response.params[:certificate_info]).to be_present
      expect(@response.params[:fulfillment]).to be_nil
    end
  end

  context 'when returned success response with fulfillment option' do
    let(:cassette_title) { 'with_fulfillment' }
    let(:order_status) { 'completed_issue' }

    let(:request) do
      GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789', options: {fulfillment: true})
    end

    it_behaves_like 'succeeds'

    it 'exists fulfillment option response' do
      expect(@response.params[:certificate_info]).to be_nil
      expect(@response.params[:fulfillment]).to be_present
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'invalid_order_id')
    end

    it 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-1')
      expect(@response.error_message).to include('Internal system error.')
    end
  end
end
