require 'spec_helper'

describe GlobalSign::UrlVerificationForIssue::Response do
  before do
    VCR.use_cassette('url_verification_for_issue/' + cassette_title) do
      @response = client.process(request)
    end
  end

  context 'when returned success response' do
    let(:cassette_title) { 'success' }

    let(:request) do
      GlobalSign::UrlVerificationForIssue::Request.new()
    end

    xit 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    xit 'response includes url_verification_for_issue params' do
      # expect response params be_present
    end
  end

  context 'when returned error response' do
    let(:cassette_title) { 'failure' }

    let(:request) do
      GlobalSign::UrlVerificationForIssue::Request.new()
    end

    xit 'fails' do
      expect(@response.error?).to be_truthy
      # expect error detail be_present
    end
  end
end
