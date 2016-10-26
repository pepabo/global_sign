require 'spec_helper'

describe GlobalSign::OrderGetterByOrderId::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('order_getter_by_order_id/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789')
    end

    it 'succeeds' do
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
      expect(@response.order_status_text).to eq('initial')
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