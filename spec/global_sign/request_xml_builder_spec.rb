require 'spec_helper'

describe GlobalSign::RequestXmlBuilder do
  describe '.build_xml' do
    let(:request) do
      GlobalSign::UrlVerification::Request.new(
        order_kind: 'new',
        csr: 'xxxxx',
        contract_info: GlobalSign.contract_information,
      )
    end

    let(:xml) { File.read('spec/fixtures/global_sign_request.xml') }

    subject { GlobalSign::RequestXmlBuilder.build_xml(action: request.action, params: request.params) }

    before do
      GlobalSign.contract do |contract_information|
        contract_information.first_name = 'Pepabo'
        contract_information.last_name = 'Taro'
        contract_information.phone_number = '090-1234-5678'
        contract_information.email = 'pepabo.taro@example.com'
      end
    end

    it 'returns xml for GlobalSign API request' do
      is_expected.to eq(Nokogiri::XML(xml).root.to_xml)
    end
  end
end
