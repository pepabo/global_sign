require 'spec_helper'

describe GlobalSign::GetOrderByOrderId::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('get_order_by_order_id/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::GetOrderByOrderId::Request.new
    end

    xit 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    xit 'response includes url_verification params' do
      expect(@response.params[:order_id]).to be_present
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::GetOrderByOrderId::Request.new
    end

    xit 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-103')
      expect(@response.error_field).to eq('OrderRequestParameter.OrderKind')
      expect(@response.error_message).to include('Parameter length check error.')
    end
  end
end
