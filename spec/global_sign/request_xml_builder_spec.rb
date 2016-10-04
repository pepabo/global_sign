require 'spec_helper'

describe GlobalSign::RequestXmlBuilder do
  describe '.build_xml' do
    let(:contract) do
      GlobalSign::Contract.new(
        first_name:   'Pepabo',
        last_name:    'Taro',
        phone_number: '090-1234-5678',
        email:        'pepabo.taro@example.com',
      )
    end

    let(:request) do
      GlobalSign::UrlVerification::Request.new(
        order_kind:        'new',
        validity_period:   1,
        csr:               'xxxxx',
        contract_info:     contract,
      )
    end

    let(:xml) { File.read('spec/fixtures/global_sign_request.xml') }

    subject { GlobalSign::RequestXmlBuilder.build_xml(action: request.action, params: request.params) }

    it 'returns xml for GlobalSign API request' do
      is_expected.to eq(Nokogiri::XML(xml).root.to_xml)
    end
  end
end
