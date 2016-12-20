require 'spec_helper'

describe GlobalSign::DnsVerificationForIssue::Response do
  let(:client) { GlobalSign::Client.new }

  before do
    VCR.use_cassette('dns_verification_for_issue/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::DnsVerificationForIssue::Request.new(
        order_id:      'xxxx123456789',
        approver_fqdn: 'www.example.com',
      )
    end

    it 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'returns response includes dns_verification_for_issue params' do
      expect(@response.params[:certificate_info]).to be_present
      expect(@response.params[:fulfillment][:ca_certificates].first).to be_present
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::DnsVerificationForIssue::Request.new(
        order_id:      'xxxx123456789',
        approver_fqdn: 'www.example.com',
      )
    end

    it 'fails' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-4147')
      expect(@response.error_message).to include('We were unable to verify the domain http://example.com.')
    end
  end
end
