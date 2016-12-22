require 'spec_helper'

describe GlobalSign::OrderGetterByOrderId::Request do

  describe '#params' do
    subject { GlobalSign::OrderGetterByOrderId::Request.new(order_id: 'xxxx123456789', options: options).params }

    context 'when no options' do
      let(:options) { {} }
      it do
        expect(subject).to eq(
          {
            OrderID: 'xxxx123456789'
          }
        )
      end
    end

    context 'when adds certificate_info option' do
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

    context 'when adds fulfillment option' do
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

    context 'when adds multiple options' do
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
end
