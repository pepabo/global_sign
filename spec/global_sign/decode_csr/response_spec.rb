require 'spec_helper'

describe GlobalSign::DecodeCsr::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('decode_csr/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::DecodeCsr::Request.new(csr: example_csr, product_type: 'DV_LOW')
    end

    it 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'response includes decode_csr params' do
      expect(@response.params[:csr_data]).to be_present
      expect(@response.params[:csr_data][:common_name]).to be_present
      expect(@response.params[:csr_data][:organization]).to be_present
      expect(@response.params[:csr_data][:organization_unit]).to be_present
      expect(@response.params[:csr_data][:locality]).to be_present
      expect(@response.params[:csr_data][:state]).to be_present
      expect(@response.params[:csr_data][:country]).to be_present
      expect(@response.params[:csr_data][:email_address]).to be_present
      expect(@response.params[:csr_data][:key_length]).to be_present
      expect(@response.params[:certificate_preview]).to be_present
      expect(@response.params[:certificate_preview][:common_name]).to be_present
      expect(@response.params[:certificate_preview][:organization]).to be_present
      expect(@response.params[:certificate_preview][:organization_unit]).to be_present
      expect(@response.params[:certificate_preview][:locality]).to be_present
      expect(@response.params[:certificate_preview][:state]).to be_present
      expect(@response.params[:certificate_preview][:country]).to be_present
      expect(@response.params[:certificate_preview][:email_address]).to be_present
      expect(@response.params[:certificate_preview][:key_length]).to be_present
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::DecodeCsr::Request.new(csr: example_csr, product_type: 'INVALID')
    end

    it 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-1')
      expect(@response.error_message).to include('Internal system error.')
    end
  end
end
