require 'spec_helper'

describe GlobalSign::Request do
  let(:request) do
    GlobalSign::UrlVerification::Request.new(
      order_kind:    'new',
      csr:           'xxxxx',
      contract_info: GlobalSign.contract_information,
    )
  end

  describe '#to_xml' do
    let(:action_name) { 'URLVerification' }
    let(:params) { request.auth_token_params.merge(request.params) }

    before do
      allow(request).to receive(:action).and_return(action_name)
      allow(request).to receive(:params).and_return({})
    end

    it 'calls RequestXmlBuilder.build_xml' do
      expect(GlobalSign::RequestXmlBuilder).to receive(:build_xml).
        with(action: action_name, params: params)
      request.to_xml
    end
  end

  describe '#auth_token_params' do
    let(:user_name) { 'PAR12345_taro' }
    let(:password) { 'password' }

    before do
      GlobalSign.configure do |config|
        config.user_name = user_name
        config.password  = password
      end
    end

    it 'returns hash' do
      expect(request.auth_token_params).to eq(
        {
          OrderRequestHeader: {
            AuthToken: {
              UserName: user_name,
              Password: password,
            }
          }
        }
      )
    end
  end
end
