require 'spec_helper'

describe GlobalSign::Request do
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
      product_code:           'DV_LOW_URL',
      order_kind:             'new',
      validity_period_months: 6,
      csr:                    'xxxxx',
      contract_info:          contract,
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
      GlobalSign.configure do |configuration|
        configuration.user_name = user_name
        configuration.password  = password
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
