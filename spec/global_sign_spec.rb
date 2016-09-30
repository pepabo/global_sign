require 'spec_helper'

describe GlobalSign do
  it 'has a version number' do
    expect(GlobalSign::VERSION).to be_present
  end

  describe '.configure' do
    before do
      GlobalSign.configure { |configuration| configuration.user_name = 'PAR12345_taro' }
    end

    it 'proxies to GlobalSign configuration' do
      expect(GlobalSign.configuration.user_name).to eq('PAR12345_taro')
    end
  end

  describe '.contract' do
    before do
      GlobalSign.contract do |contract_information|
        contract_information.first_name   = 'Pepabo'
        contract_information.last_name    = 'Taro'
        contract_information.phone_number = '090-1234-5678'
        contract_information.email        = 'pepabo.taro@example.com'
      end
    end

    it 'proxies to GlobalSign contract information' do
      expect(GlobalSign.contract_information.first_name).to eq('Pepabo')
    end
  end
end
