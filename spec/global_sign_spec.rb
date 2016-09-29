require 'spec_helper'

describe GlobalSign do
  it 'has a version number' do
    expect(GlobalSign::VERSION).to be_present
  end

  describe '.configure' do
    before do
      GlobalSign.configure { |config| config.user_name = 'PAR12345_hoge' }
    end

    it 'proxies to GlobalSign configuration' do
      expect(GlobalSign.configuration.user_name).to eq('PAR12345_hoge')
    end
  end

  describe '.contract' do
    before do
      GlobalSign.contract { |contract_information| contract_information.first_name = 'Yamada' }
    end

    it 'proxies to GlobalSign contract information' do
      expect(GlobalSign.contract_information.first_name).to eq('Yamada')
    end
  end
end
