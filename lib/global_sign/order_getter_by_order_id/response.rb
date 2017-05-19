module GlobalSign
  module OrderGetterByOrderId
    class Response < GlobalSign::Response
      module XPath
        ORDER_ID            = '//Response/OrderID'
        ORDER_STATUS        = '//Response/OrderDetail/OrderInfo/OrderStatus'
        MODIFICATION_EVENTS = '//Response/OrderDetail/ModificationEvents'

        # options
        CERTIFICATE_INFO    = '//Response/OrderDetail/CertificateInfo'
        FULFILLMENT         = '//Response/OrderDetail/Fulfillment'
        CA_CERTIFICATES     = '//Response/OrderDetail/Fulfillment/CACertificates'
        SERVER_CERTIFICATE  = '//Response/OrderDetail/Fulfillment/ServerCertificate'
      end

      def response_header
        :OrderResponseHeader
      end

      def params
        return @params if @params
        _params = {
          order_id:            @xml.xpath(XPath::ORDER_ID).text,
          order_status:        @xml.xpath(XPath::ORDER_STATUS).text,
          modification_events: modification_events_list
        }

        # options
        _params[:certificate_info] = {
            certificate_status: certificate_info.at('CertificateStatus').text,
            common_name:        certificate_info.at('CommonName').text,
            start_date:         (certificate_info.at('StartDate').text  if certificate_info.at('StartDate').present?),
            end_date:           (certificate_info.at('EndDate').text  if certificate_info.at('EndDate').present?),
            subject_name:       (certificate_info.at('SubjectName').text if certificate_info.at('SubjectName').present?),
        } if certificate_info.text.present?

        _params[:fulfillment] = {
            ca_certificates: ca_certificates_list,
            server_certificate: {
              x509_cert:  server_certificate.at('X509Cert').text,
              pkcs7_cert: server_certificate.at('PKCS7Cert').text,
            }
        } if fulfillment.text.present?

        @params = _params
      end

      def order_status_text
        OrderStatus::STATUS_MAPPING[params[:order_status]]
      end

      private

      def modification_events_list
        @xml.xpath(XPath::MODIFICATION_EVENTS).children.map do |element|
          {
            name:      element.at('ModificationEventName').text,
            timestamp: element.at('ModificationEventTimestamp').text,
          }
        end
      end

      def certificate_info
        @xml.xpath(XPath::CERTIFICATE_INFO)
      end

      def fulfillment
        @xml.xpath(XPath::FULFILLMENT)
      end

      def ca_certificates_list
        @xml.xpath(XPath::CA_CERTIFICATES).children.map do |c|
          {
            ca_cert_type: c.at('CACertType').text,
            ca_cert:      c.at('CACert').text,
          }
        end
      end

      def server_certificate
        @xml.xpath(XPath::SERVER_CERTIFICATE)
      end
    end
  end
end
