require 'spec_helper'

describe GlobalSign::CsrDecode::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('decode_csr/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::CsrDecode::Request.new(csr: example_csr, product_type: 'DV_LOW')
    end

    it 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'response includes decode_csr params' do
      expect(@response.params[:csr_data]).to be_present
      expect(@response.params[:csr_data][:common_name]).not_to be_nil
      expect(@response.params[:csr_data][:organization]).not_to be_nil
      expect(@response.params[:csr_data][:organization_unit]).not_to be_nil
      expect(@response.params[:csr_data][:locality]).not_to be_nil
      expect(@response.params[:csr_data][:state]).not_to be_nil
      expect(@response.params[:csr_data][:country]).not_to be_nil
      expect(@response.params[:csr_data][:email_address]).not_to be_nil
      expect(@response.params[:csr_data][:key_length]).not_to be_nil
      expect(@response.params[:certificate_preview]).to be_present
      expect(@response.params[:certificate_preview][:common_name]).not_to be_nil
      expect(@response.params[:certificate_preview][:organization]).not_to be_nil
      expect(@response.params[:certificate_preview][:organization_unit]).not_to be_nil
      expect(@response.params[:certificate_preview][:locality]).not_to be_nil
      expect(@response.params[:certificate_preview][:state]).not_to be_nil
      expect(@response.params[:certificate_preview][:country]).not_to be_nil
      expect(@response.params[:certificate_preview][:email_address]).not_to be_nil
      expect(@response.params[:certificate_preview][:key_length]).not_to be_nil
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::CsrDecode::Request.new(csr: example_csr, product_type: 'INVALID')
    end

    it 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-1')
      expect(@response.error_message).to include('Internal system error.')
    end
  end
end
