require 'spec_helper'

describe GlobalSign::DVApproverList::Response do
  let(:client) { GlobalSign::Client.new }
  let(:contract) do
    GlobalSign::Contract.new(
      first_name:   'Pepabo',
      last_name:    'Taro',
      phone_number: '090-1234-5678',
      email:        'pepabo.taro@example.com'
    )
  end
  let(:approvers_suffix) do
    /admin|administrator|hostmaster|postmaster|webmaster/
  end

  subject { GlobalSign::DVApproverList::Request.new(url) }

  before do
    VCR.use_cassette('dv_approver_list/' + cassette_title) do
      @response = client.process(subject)
    end
  end

  context 'when is a success response' do
    let(:url) { 'example.com' }
    let(:cassette_title) { 'success' }

    it 'succeeds' do
      expect(@response.success?).to be_truthy
      expect(@response.error_code).to be_nil
      expect(@response.error_field).to be_nil
      expect(@response.error_message).to be_nil
    end

    it 'includes orderID and list of approvers' do
      expect(@response.params[:order_id]).to be_present
      expect(@response.params[:order_id]).to eq 'xxxx123456789'
      expect(@response.params[:approvers]).to_not be_nil

      @response.params[:approvers].each do |approver|
        expect(approver[:email]).to end_with "@#{url}"
        expect(approver[:email]).to match approvers_suffix
        expect(approver[:type]).to eq 'GENERIC'
      end
    end
  end

  context 'when is a failure response' do
    let(:url) { nil }
    let(:cassette_title) { 'failure' }
    let(:error_message) do
      'Mandatory parameter missing. Please check that the parameters match the'\
      ' API specification. Please review the specific ErrorMessage returned in'\
      ' the XML response for parameter details and consult the XML Field'\
      ' definitions section of the applicable API document.'
    end

    it 'fails' do
      expect(@response.success?).to be_falsy
      expect(@response.error_code).to_not be_nil
      expect(@response.error_field).to_not be_nil
      expect(@response.error_message).to_not be_nil
    end

    it 'includes the errors' do
      expect(@response.error?).to be_truthy
      expect(@response.error_code).to eq('-102')
      expect(@response.error_message).to eq error_message
    end
  end
end
