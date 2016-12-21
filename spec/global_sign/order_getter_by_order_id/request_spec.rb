require 'spec_helper'

describe GlobalSign::OrderGetterByOrderId::Request do

  subject { GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789', options: options).params }

  context 'no options' do
    let(:options) { {} }
    it do
      expect(subject).to eq(
        {
          OrderID: 'xxxx123456789'
        }
      )
    end
  end

  context 'add certificate_info option' do
    let(:options) { { certificate_info: true } }
    it do
      expect(subject).to eq(
        {
          OrderID: 'xxxx123456789',
          OrderQueryOption: {
            ReturnCertificateInfo: true
          }
        }
      )
    end
  end

  context 'add fulfillment option' do
    let(:options) { { fulfillment: true } }
    it do
      expect(subject).to eq(
        {
          OrderID: 'xxxx123456789',
          OrderQueryOption: {
            ReturnFulfillment: true
          }
        }
      )
    end
  end

  context 'add multiple options' do
    let(:options) { { certificate_info: true, fulfillment: true } }
    it do
      expect(subject).to eq(
        {
          OrderID: 'xxxx123456789',
          OrderQueryOption: {
            ReturnCertificateInfo: true,
            ReturnFulfillment: true
          }
        }
      )
    end
  end
end
